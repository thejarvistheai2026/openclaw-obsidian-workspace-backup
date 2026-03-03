# QuickAdd Article Capture

Use a hotkey to create articles directly in `2. the-brain/3. resources/Articles/`

## Setup

### 1. Install QuickAdd
- Settings → Community Plugins → Browse → "QuickAdd" → Install & Enable

### 2. Create the Macro

Settings → QuickAdd → **Manage Macros** → **Add Macro**

**Macro Name:** `New Article`

---

### 3. Add Template Choice

Click **Configure** on your macro → **Add Choice** → **Template**

| Setting | Value |
|---------|-------|
| Choice Name | `Article from Template` |
| Template Path | `Templates/article-template.md` |
| Create in folder | `2. the-brain/3. resources/Articles` |
| File Name Format | `{{DATE:YYYY-MM-DD}} - {{VALUE:articleTitle}}` |
| Open file | ✅ Checked |

---

### 4. Create the Template

Create folder: `Templates/` (at vault root)

Create file: `Templates/article-template.md`

```markdown
---
category: article
created: {{DATE:YYYY-MM-DD}}
tags: []
---

# {{articleTitle}}

## Summary


## Key Points
- 

## Notes


## Links
- 
```

---

### 5. Set Up Capture

Click **Add Choice** → **Capture**

| Setting | Value |
|---------|-------|
| Choice Name | `Get Article Title` |
| Capture to | `{{MACRO:EMPTY}}` (we'll use the template instead) |
| Capture format | `{{VALUE:articleTitle}}` |

**Actually, easier approach:** Just skip the Capture step and use a single Template choice with the filename format above.

---

### 6. Simpler Single-Step Setup

Go to **QuickAdd** → **Choices** → **Template**

| Setting | Value |
|---------|-------|
| Choice Name | `New Article` |
| Template Path | `Templates/article-template.md` |
| Create in folder | `2. the-brain/3. resources/Articles` |
| File Name Format | `{{DATE:YYYY-MM-DD}} - {{VALUE:title}}` |
| Open | ✅ Yes |
| Format syntax | `{{VALUE:title}}` → Prompts you for the title |

---

### 7. Set Hotkey

Settings → Hotkeys → Search "QuickAdd: New Article"

Assign: `Cmd/Ctrl + Shift + A` (or whatever you want)

---

## How to Use

1. Press your hotkey (`Cmd+Shift+A`)
2. Prompt appears: "What is the article title?"
3. Type: `How to Build a Second Brain`
4. File created: `2. the-brain/3. resources/Articles/2025-01-09 - How to Build a Second Brain.md`
5. Opens automatically with your template

---

## Extending It

Add more QuickAdd choices for other types:

### For Books
- Choice: `New Book`
- Folder: `2. the-brain/3. resources/Books`
- Template: `Templates/book-template.md`

### For People
- Choice: `New Person`
- Folder: `4. CRM/People`
- Template: `Templates/person-template.md`

---

## Templates You Can Copy

### Book Template (`Templates/book-template.md`)

```markdown
---
category: book
author: 
read_status: 
tags: []
rating: 
---

# {{VALUE:title}}

**Author:** 

## Summary


## Key Takeaways
- 

## Quotes
- 

## Personal Notes

```

### Person Template (`Templates/person-template.md`)

```markdown
---
category: person
company: 
relationship: 
tags: []
last_contact: {{DATE:YYYY-MM-DD}}
---

# {{VALUE:title}}

## Contact Info
- Email: 
- Phone: 
- Social: 

## Context
- How we met: 
- Role: 

## Notes


## Interactions
- {{DATE:YYYY-MM-DD}} - 
```
