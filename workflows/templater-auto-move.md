# Templater Auto-Move Workflow

Automatically move notes to the correct folder based on frontmatter category.

## What It Does

When you save a note at the vault root with `category: article` in the frontmatter, it automatically moves to `2. the-brain/3. resources/Articles/`.

## Setup

### 1. Install Templater
- Settings → Community Plugins → Browse → "Templater" → Install & Enable

### 2. Create the Auto-Move Script

Create folder: `.obsidian/scripts/` (if it doesn't exist)

Create file: `.obsidian/scripts/auto-move-article.js`

```javascript
async function autoMoveArticle(tp) {
    const file = tp.file.find_tfile(tp.file.path(true));
    const metadata = app.metadataCache.getFileCache(file)?.frontmatter;
    
    // Only process files at root level
    if (file.path.includes('/')) {
        return;
    }
    
    // Check if category is "article"
    if (metadata?.category === "article") {
        const targetFolder = "2. the-brain/3. resources/Articles";
        const targetPath = `${targetFolder}/${file.name}`;
        
        // Create folder if it doesn't exist
        const folder = app.vault.getAbstractFileByPath(targetFolder);
        if (!folder) {
            await app.vault.createFolder(targetFolder);
        }
        
        // Move the file
        await app.fileManager.renameFile(file, targetPath);
        new Notice(`Moved to ${targetFolder}`);
    }
}

module.exports = autoMoveArticle;
```

### 3. Create the Trigger Template

Create folder: `Templates/` (at vault root)

Create file: `Templates/article-auto-move.md`

```markdown
<%*
await tp.user.autoMoveArticle(tp);
-%>
```

### 4. Configure Templater

Settings → Templater:
- **Template folder location:** `Templates`
- **Script folder:** `.obsidian/scripts`
- Toggle ON: "Trigger Templater on new file creation"
- Toggle ON: "Enable user scripts functions"

### 5. Set Up Folder Template

In Templater settings → Folder Templates:
- Click "Add New"
- **Folder:** `/` (root)
- **Template:** `Templates/article-auto-move.md`

## How to Use

1. Create a new note at vault root (Ctrl/Cmd + N)
2. Add to frontmatter:
   ```yaml
   ---
   category: article
   title: Your Article Title
   ---
   ```
3. Save the file (Ctrl/Cmd + S)
4. The file automatically moves to `2. the-brain/3. resources/Articles/`

## Extending It

Add more categories by editing the script:

```javascript
const moves = {
    "article": "2. the-brain/3. resources/Articles",
    "book": "2. the-brain/3. resources/Books",
    "person": "4. CRM/People",
    // add more...
};

const targetFolder = moves[metadata?.category];
if (targetFolder) {
    // ... move logic
}
```

## Troubleshooting

- **Not moving?** Check the console (Ctrl+Shift+I) for errors
- **Folder doesn't exist?** The script auto-creates it
- **Script not found?** Verify the path in Templater settings
