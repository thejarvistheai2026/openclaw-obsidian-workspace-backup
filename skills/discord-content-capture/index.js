#!/usr/bin/env node
/**
 * Discord Content Capture Skill
 * Auto-processes URLs from Discord #Content Capture 2 channel
 */

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

// Configuration
const CONFIG = {
  targetChannel: 'Content Capture 2',
  outputDir: '/Users/ava/Mac-Mini-Obsidian-Vault/2. the-brain/3. resources/Articles',
  defuddleApi: 'https://defuddle.md'
};

// URL detection regex
const URL_REGEX = /(https?:\/\/[^\s]+)/gi;

// Type detection
function detectType(url) {
  if (url.includes('youtube.com') || url.includes('youtu.be')) {
    return 'youtube';
  }
  if (url.includes('twitter.com') || url.includes('x.com')) {
    return 'twitter';
  }
  if (url.includes('substack.com')) {
    return 'substack';
  }
  return 'article';
}

// Generate slug from title
function generateSlug(title) {
  return title
    .toLowerCase()
    .replace(/[^\w\s-]/g, '')
    .replace(/\s+/g, '-')
    .substring(0, 100);
}

// Call defuddle API
async function defuddleCapture(url) {
  try {
    console.log(`Capturing: ${url}`);
    const result = execSync(`curl -sL "${CONFIG.defuddleApi}/${url}"`, {
      encoding: 'utf8',
      timeout: 30000
    });
    return result;
  } catch (error) {
    console.error('Defuddle API error:', error.message);
    throw error;
  }
}

// Extract title from markdown
function extractTitle(markdown) {
  // Try H1 first
  const h1Match = markdown.match(/^# (.+)$/m);
  if (h1Match) return h1Match[1].trim();
  
  // Try frontmatter title
  const fmMatch = markdown.match(/^title:\s*(.+)$/m);
  if (fmMatch) return fmMatch[1].trim();
  
  // Fallback: first line
  const firstLine = markdown.split('\n')[0];
  return firstLine.substring(0, 100) || 'Untitled';
}

// Extract author from markdown
function extractAuthor(markdown) {
  const fmMatch = markdown.match(/^author:\s*(.+)$/m);
  return fmMatch ? fmMatch[1].trim() : '';
}

// Format with proper frontmatter
function formatDocument(url, markdown, type) {
  const today = new Date().toISOString().split('T')[0];
  const title = extractTitle(markdown);
  const author = extractAuthor(markdown);
  
  const frontmatter = `---
captured: ${today}
source_url: ${url}
title: "${title.replace(/"/g, '\\"')}"${author ? `\nauthor: "${author.replace(/"/g, '\\"')}"` : ''}
type: ${type}
---

`;
  
  return frontmatter + markdown;
}

// Save to vault
function saveToVault(content, title, type) {
  const slug = generateSlug(title);
  const filename = `${slug}.md`;
  const filepath = path.join(CONFIG.outputDir, filename);
  
  // Ensure directory exists
  if (!fs.existsSync(CONFIG.outputDir)) {
    fs.mkdirSync(CONFIG.outputDir, { recursive: true });
  }
  
  // Check for duplicates
  let finalPath = filepath;
  let counter = 1;
  while (fs.existsSync(finalPath)) {
    const baseSlug = slug.replace(/-\d+$/, '');
    finalPath = path.join(CONFIG.outputDir, `${baseSlug}-${counter}.md`);
    counter++;
  }
  
  fs.writeFileSync(finalPath, content, 'utf8');
  console.log(`Saved to: ${finalPath}`);
  return finalPath;
}

// Main handler
async function handleDiscordMessage(message) {
  // Check if message is from target channel
  if (message.channel.name !== CONFIG.targetChannel) {
    return null;
  }
  
  // Extract URLs
  const urls = message.content.match(URL_REGEX);
  if (!urls || urls.length === 0) {
    return null;
  }
  
  const results = [];
  
  for (const url of urls) {
    try {
      const type = detectType(url);
      const markdown = await defuddleCapture(url);
      const title = extractTitle(markdown);
      const formatted = formatDocument(url, markdown, type);
      const savedPath = saveToVault(formatted, title, type);
      
      results.push({
        url,
        title,
        type,
        savedTo: savedPath
      });
    } catch (error) {
      console.error(`Failed to capture ${url}:`, error.message);
      results.push({
        url,
        error: error.message
      });
    }
  }
  
  return results;
}

// Export for OpenClaw
module.exports = {
  name: 'discord-content-capture',
  version: '1.0.0',
  description: 'Auto-capture URLs from Discord to Obsidian via defuddle',
  channels: [CONFIG.targetChannel],
  handler: handleDiscordMessage
};

// If run directly (for testing)
if (require.main === module) {
  console.log('Discord Content Capture Skill loaded');
  console.log(`Target channel: ${CONFIG.targetChannel}`);
  console.log(`Output directory: ${CONFIG.outputDir}`);
}
