# Creating an Obsidian Plugin

Building your own Obsidian plugin from scratch.

---

## Prerequisites

- **Node.js** (v18+) — `brew install node`
- **Basic JavaScript/TypeScript knowledge**
- **Obsidian app** installed locally

---

## Step 1: Scaffold Your Plugin

Obsidian provides an official template. Run this in your terminal:

```bash
# Create a folder for your plugin
cd ~/Projects  # or wherever you want it

# Clone the official template
git clone https://github.com/obsidianmd/obsidian-sample-plugin.git my-obsidian-plugin

cd my-obsidian-plugin

# Install dependencies
npm install

# Rename the plugin
```

---

## Step 2: Configure Your Plugin

### Edit `manifest.json`

This is your plugin's identity:

```json
{
  "id": "my-awesome-plugin",
  "name": "My Awesome Plugin",
  "version": "1.0.0",
  "minAppVersion": "0.15.0",
  "description": "Describe what your plugin does",
  "author": "Your Name",
  "authorUrl": "https://yourwebsite.com",
  "isDesktopOnly": false
}
```

### Edit `package.json`

Update the name field:

```json
{
  "name": "my-awesome-plugin",
  "version": "1.0.0",
  ...
}
```

---

## Step 3: Understand the Structure

```
my-obsidian-plugin/
├── manifest.json          # Plugin metadata
├── package.json           # NPM config
├── tsconfig.json          # TypeScript config
├── esbuild.config.mjs     # Build script
├── versions.json          # Version compatibility
├── styles.css             # Plugin styles (optional)
├── main.ts                # ⭐ Main entry point
└── README.md              # Documentation
```

**`main.ts`** is where you write your code.

---

## Step 4: Write Your First Feature

Replace `main.ts` with this starter:

```typescript
import { App, Modal, Notice, Plugin, PluginSettingTab, Setting } from 'obsidian';

// Plugin settings interface
interface MyPluginSettings {
  mySetting: string;
}

// Default settings
const DEFAULT_SETTINGS: MyPluginSettings = {
  mySetting: 'default value'
};

// Main plugin class
export default class MyAwesomePlugin extends Plugin {
  settings: MyPluginSettings;

  async onload() {
    console.log('Loading My Awesome Plugin');
    
    // Load settings
    await this.loadSettings();
    
    // Add ribbon icon in the left sidebar
    this.addRibbonIcon('dice', 'My Plugin', (evt: MouseEvent) => {
      new Notice('Hello from my plugin!');
    });
    
    // Add command (accessible via Command Palette)
    this.addCommand({
      id: 'open-sample-modal',
      name: 'Open Sample Modal',
      callback: () => {
        new SampleModal(this.app).open();
      }
    });
    
    // Add settings tab
    this.addSettingTab(new SampleSettingTab(this.app, this));
  }

  onunload() {
    console.log('Unloading My Awesome Plugin');
  }

  async loadSettings() {
    this.settings = Object.assign({}, DEFAULT_SETTINGS, await this.loadData());
  }

  async saveSettings() {
    await this.saveData(this.settings);
  }
}

// Modal dialog class
class SampleModal extends Modal {
  constructor(app: App) {
    super(app);
  }

  onOpen() {
    const { contentEl } = this;
    contentEl.setText('This is a sample modal!');
  }

  onClose() {
    const { contentEl } = this;
    contentEl.empty();
  }
}

// Settings tab class
class SampleSettingTab extends PluginSettingTab {
  plugin: MyAwesomePlugin;

  constructor(app: App, plugin: MyAwesomePlugin) {
    super(app, plugin);
    this.plugin = plugin;
  }

  display(): void {
    const { containerEl } = this;
    containerEl.empty();

    new Setting(containerEl)
      .setName('My Setting')
      .setDesc('This is a sample setting')
      .addText(text => text
        .setPlaceholder('Enter your setting')
        .setValue(this.plugin.settings.mySetting)
        .onChange(async (value) => {
          this.plugin.settings.mySetting = value;
          await this.plugin.saveSettings();
        }));
  }
}
```

---

## Step 5: Build and Test

### Build your plugin

```bash
npm run build
```

### Install in Obsidian (Development Mode)

1. Open Obsidian → Settings → Community Plugins
2. Turn on **Developer Mode**
3. Click **Open plugins folder**
4. Create a folder with your plugin ID: `my-awesome-plugin`
5. Copy these files from your project:
   - `main.js`
   - `manifest.json`
   - `styles.css` (if you have one)

### Enable your plugin

1. In Obsidian → Settings → Community Plugins
2. Click **Turn on** (if not already on)
3. Find your plugin in the list
4. Toggle it **ON**

### Auto-rebuild on changes

For development, use:

```bash
npm run dev
```

This watches for changes and rebuilds automatically. Just reload Obsidian (Cmd+R) to see changes.

---

## Common Plugin Features

### Add a Command with Hotkey

```typescript
this.addCommand({
  id: 'my-command',
  name: 'My Command',
  hotkeys: [{ modifiers: ['Ctrl', 'Shift'], key: 'a' }],
  callback: () => {
    // Your code here
  }
});
```

### Listen to File Events

```typescript
// When active file changes
this.registerEvent(
  this.app.workspace.on('active-leaf-change', (leaf) => {
    console.log('Active file changed');
  })
);

// When file is created
this.registerEvent(
  this.app.vault.on('create', (file) => {
    console.log('File created:', file.path);
  })
);

// When file is modified
this.registerEvent(
  this.app.vault.on('modify', (file) => {
    console.log('File modified:', file.path);
  })
);
```

### Read/Write Files

```typescript
// Read file
const content = await this.app.vault.read(file);

// Write file
await this.app.vault.modify(file, newContent);

// Create new file
const newFile = await this.app.vault.create('path/to/file.md', '# Hello');
```

### Access Frontmatter

```typescript
import { parseYaml, stringifyYaml } from 'obsidian';

// Get file cache with frontmatter
const cache = this.app.metadataCache.getFileCache(file);
const frontmatter = cache?.frontmatter;

// Modify frontmatter
const content = await this.app.vault.read(file);
const newFrontmatter = { ...frontmatter, category: 'article' };
const newContent = '---\n' + stringifyYaml(newFrontmatter) + '---\n' + content.split('---').slice(2).join('---');
await this.app.vault.modify(file, newContent);
```

### Create a Custom View

```typescript
import { ItemView, WorkspaceLeaf } from 'obsidian';

const VIEW_TYPE_MY_VIEW = 'my-view';

class MyView extends ItemView {
  constructor(leaf: WorkspaceLeaf) {
    super(leaf);
  }

  getViewType() {
    return VIEW_TYPE_MY_VIEW;
  }

  getDisplayText() {
    return 'My Custom View';
  }

  async onOpen() {
    const container = this.containerEl.children[1];
    container.empty();
    container.createEl('h4', { text: 'My Custom View' });
  }
}

// Register in onload()
this.registerView(
  VIEW_TYPE_MY_VIEW,
  (leaf) => new MyView(leaf)
);

// Open the view
this.app.workspace.detachLeavesOfType(VIEW_TYPE_MY_VIEW);
await this.app.workspace.getRightLeaf(false).setViewState({
  type: VIEW_TYPE_MY_VIEW,
  active: true
});
```

### Add a Status Bar Item

```typescript
const statusBarItem = this.addStatusBarItem();
statusBarItem.setText('Status: Ready');
```

---

## Build Your QuickAdd Alternative

Here's a custom plugin that creates files in specific folders:

```typescript
import { App, Plugin, PluginSettingTab, Setting, TFile, TFolder } from 'obsidian';

interface QuickAddSettings {
  articleFolder: string;
  bookFolder: string;
  personFolder: string;
}

const DEFAULT_SETTINGS: QuickAddSettings = {
  articleFolder: '2. the-brain/3. resources/Articles',
  bookFolder: '2. the-brain/3. resources/Books',
  personFolder: '4. CRM/People'
};

export default class QuickAddPlugin extends Plugin {
  settings: QuickAddSettings;

  async onload() {
    await this.loadSettings();
    
    // Add commands for each type
    this.addCommand({
      id: 'create-article',
      name: 'Create Article',
      callback: () => this.createFile('article'),
      hotkeys: [{ modifiers: ['Ctrl', 'Shift'], key: 'a' }]
    });
    
    this.addCommand({
      id: 'create-book',
      name: 'Create Book',
      callback: () => this.createFile('book'),
      hotkeys: [{ modifiers: ['Ctrl', 'Shift'], key: 'b' }]
    });
    
    this.addCommand({
      id: 'create-person',
      name: 'Create Person',
      callback: () => this.createFile('person'),
      hotkeys: [{ modifiers: ['Ctrl', 'Shift'], key: 'p' }]
    });
    
    this.addSettingTab(new QuickAddSettingTab(this.app, this));
  }

  async createFile(type: 'article' | 'book' | 'person') {
    // Get title from user
    const title = await this.promptForTitle();
    if (!title) return;
    
    // Determine folder
    let folder: string;
    let template: string;
    
    switch(type) {
      case 'article':
        folder = this.settings.articleFolder;
        template = this.getArticleTemplate(title);
        break;
      case 'book':
        folder = this.settings.bookFolder;
        template = this.getBookTemplate(title);
        break;
      case 'person':
        folder = this.settings.personFolder;
        template = this.getPersonTemplate(title);
        break;
    }
    
    // Ensure folder exists
    const folderPath = folder;
    const folderExists = this.app.vault.getFolderByPath(folderPath);
    if (!folderExists) {
      await this.app.vault.createFolder(folderPath);
    }
    
    // Create file
    const date = new Date().toISOString().split('T')[0];
    const fileName = type === 'article' 
      ? `${date} - ${title}.md`
      : `${title}.md`;
    const filePath = `${folderPath}/${fileName}`;
    
    const file = await this.app.vault.create(filePath, template);
    
    // Open the new file
    await this.app.workspace.openLinkText(filePath, '', true);
  }
  
  async promptForTitle(): Promise<string | null> {
    // Simple prompt - in real plugin, use a Modal
    const title = window.prompt('Enter title:');
    return title || null;
  }
  
  getArticleTemplate(title: string): string {
    return `---\ncategory: article\ncreated: ${new Date().toISOString().split('T')[0]}\ntags: []\n---\n\n# ${title}\n\n## Summary\n\n\n## Key Points\n- \n\n## Notes\n\n\n## Links\n- `;
  }
  
  getBookTemplate(title: string): string {
    return `---\ncategory: book\nauthor: \nread_status: \ntags: []\nrating: \n---\n\n# ${title}\n\n**Author:** \n\n## Summary\n\n\n## Key Takeaways\n- \n\n## Quotes\n- \n\n## Personal Notes\n`;
  }
  
  getPersonTemplate(title: string): string {
    return `---\ncategory: person\ncompany: \nrelationship: \ntags: []\nlast_contact: ${new Date().toISOString().split('T')[0]}\n---\n\n# ${title}\n\n## Contact Info\n- Email: \n- Phone: \n- Social: \n\n## Context\n- How we met: \n- Role: \n\n## Notes\n\n\n## Interactions\n- ${new Date().toISOString().split('T')[0]} - `;
  }

  async loadSettings() {
    this.settings = Object.assign({}, DEFAULT_SETTINGS, await this.loadData());
  }

  async saveSettings() {
    await this.saveData(this.settings);
  }
}

class QuickAddSettingTab extends PluginSettingTab {
  plugin: QuickAddPlugin;

  constructor(app: App, plugin: QuickAddPlugin) {
    super(app, plugin);
    this.plugin = plugin;
  }

  display(): void {
    const { containerEl } = this;
    containerEl.empty();

    containerEl.createEl('h2', { text: 'QuickAdd Settings' });

    new Setting(containerEl)
      .setName('Article Folder')
      .setDesc('Where to create article notes')
      .addText(text => text
        .setValue(this.plugin.settings.articleFolder)
        .onChange(async (value) => {
          this.plugin.settings.articleFolder = value;
          await this.plugin.saveSettings();
        }));
    
    new Setting(containerEl)
      .setName('Book Folder')
      .setDesc('Where to create book notes')
      .addText(text => text
        .setValue(this.plugin.settings.bookFolder)
        .onChange(async (value) => {
          this.plugin.settings.bookFolder = value;
          await this.plugin.saveSettings();
        }));
    
    new Setting(containerEl)
      .setName('Person Folder')
      .setDesc('Where to create person notes')
      .addText(text => text
        .setValue(this.plugin.settings.personFolder)
        .onChange(async (value) => {
          this.plugin.settings.personFolder = value;
          await this.plugin.saveSettings();
        }));
  }
}
```

---

## Resources

- **Official Docs**: https://docs.obsidian.md/Plugins/Getting+started/Build+a+plugin
- **API Reference**: https://docs.obsidian.md/Reference/TypeScript+API
- **Sample Plugin**: https://github.com/obsidianmd/obsidian-sample-plugin
- **Developer Discord**: https://discord.com/invite/obsidianmd

---

## Publishing Your Plugin

When ready to share:

1. Create a GitHub release
2. Include `manifest.json`, `main.js`, `styles.css`
3. Submit to Obsidian Community Plugins repo: https://github.com/obsidianmd/obsidian-releases
