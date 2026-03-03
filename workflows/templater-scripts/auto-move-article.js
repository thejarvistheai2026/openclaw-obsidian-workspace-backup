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
