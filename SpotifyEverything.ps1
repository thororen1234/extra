# Download and execute Spicetify.ps1
Write-Host "Downloading and executing Spicetify script."
iwr -useb https://raw.githubusercontent.com/thororen1234/extra/refs/heads/main/Spicetify.ps1 | iex

Function Update-App {
    param (
        [string]$AppName,
        [string]$DownloadUri,
        [string]$ArchiveName,
        [string]$ExtractFolder,
        [string]$TargetFolder
    )
    try {
        Write-Host "Processing $AppName"

        # Remove old app if exists
        $OldPath = "$env:APPDATA\spicetify\CustomApps\$TargetFolder"
        if (Test-Path $OldPath) {
            Write-Host "Removing old $AppName"
            Remove-Item -Recurse -Force $OldPath
        }

        # Download app archive
        $ArchivePath = "$env:APPDATA\spicetify\$ArchiveName"
        Write-Host "Downloading $ArchiveName"
        Invoke-WebRequest -Uri $DownloadUri -OutFile $ArchivePath -UseBasicParsing

        if ($AppName -eq "lyrixed") {
            Write-Host "Unzipping $ArchiveName"
            Expand-Archive -Path $ArchivePath -DestinationPath "$env:APPDATA\spicetify\CustomApps\lyrixed"
        }
        else {
            # Extract archive
            Write-Host "Unzipping $ArchiveName"
            Expand-Archive -Path $ArchivePath -DestinationPath "$env:APPDATA\spicetify\CustomApps"
        }

        # Clean up archive
        Write-Host "Cleaning up $ArchiveName"
        Remove-Item -Recurse -Force $ArchivePath

        # Move and organize files
        Write-Host "Organizing files for $AppName"
        $ExtractedPath = "$env:APPDATA\spicetify\CustomApps\$ExtractFolder"
        Move-Item $ExtractedPath "$env:APPDATA\spicetify\CustomApps\$TargetFolder"

        # Configure Spicetify
        Write-Host "Configuring Spicetify for $AppName"
        spicetify config custom_apps $appName

    }
    catch {
        Write-Host "Error processing $AppName : $($_.Exception.Message)"
    }
}


Update-App -AppName "better-library" `
    -DownloadUri "https://github.com/Sowgro/betterLibrary/archive/refs/heads/main.zip" `
    -ArchiveName "better-library.zip" `
    -ExtractFolder "betterLibrary-main\\CustomApps\\betterLibrary" `
    -TargetFolder "better-library"

Update-App -AppName "better-local-files" `
    -DownloadUri "https://github.com/Pithaya/spicetify-apps-dist/archive/refs/heads/dist/better-local-files.zip" `
    -ArchiveName "better-local-files.zip" `
    -ExtractFolder "spicetify-apps-dist-dist-better-local-files" `
    -TargetFolder "better-local-files"

Update-App -AppName "combined-playlists" `
    -DownloadUri "https://github.com/jeroentvb/spicetify-combined-playlists/archive/refs/heads/dist.zip" `
    -ArchiveName "combined-playlists.zip" `
    -ExtractFolder "spicetify-combined-playlists-dist\\combined-playlists" `
    -TargetFolder "combined-playlists"

Update-App -AppName "external-jukebox" `
    -DownloadUri "https://github.com/Pithaya/spicetify-apps-dist/archive/refs/heads/dist/eternal-jukebox.zip" `
    -ArchiveName "external-jukebox.zip" `
    -ExtractFolder "spicetify-apps-dist-dist-eternal-jukebox" `
    -TargetFolder "external-jukebox"

Update-App -AppName "history-in-sidebar" `
    -DownloadUri "https://github.com/Bergbok/Spicetify-Creations/archive/refs/heads/dist/history-in-sidebar.zip" `
    -ArchiveName "history-in-sidebar.zip" `
    -ExtractFolder "Spicetify-Creations-dist-history-in-sidebar" `
    -TargetFolder "history-in-sidebar"

Update-App -AppName "playlist-tags" `
    -DownloadUri "https://github.com/Bergbok/Spicetify-Creations/archive/refs/heads/dist/playlist-tags.zip" `
    -ArchiveName "playlist-tags.zip" `
    -ExtractFolder "Spicetify-Creations-dist-playlist-tags" `
    -TargetFolder "playlist-tags"

Update-App -AppName "visualizer" `
    -DownloadUri "https://github.com/Konsl/spicetify-visualizer/archive/refs/heads/dist.zip" `
    -ArchiveName "visualizer.zip" `
    -ExtractFolder "spicetify-visualizer-dist" `
    -TargetFolder "visualizer"

Update-App -AppName "stats" `
    -DownloadUri "https://github.com/harbassan/spicetify-apps/releases/download/stats-v1.1.1/spicetify-stats.release.zip" `
    -ArchiveName "stats.zip" `
    -ExtractFolder "stats" `
    -TargetFolder "stats"

Update-App -AppName "library" `
    -DownloadUri "https://github.com/harbassan/spicetify-apps/releases/download/library-v1.0.0/spicetify-library.release.zip" `
    -ArchiveName "library.zip" `
    -ExtractFolder "library" `
    -TargetFolder "library"

Update-App -AppName "lyrixed" `
    -DownloadUri "https://github.com/Nuzair46/Lyrixed/releases/latest/download/lyrixed.zip" `
    -ArchiveName "lyrixed.zip" `
    -ExtractFolder "lyrixed" `
    -TargetFolder "lyrixed"

Write-Host "Removing Combined Playlists Github Dir"
Remove-Item -Recurse -Force "$env:APPDATA\spicetify\CustomApps\spicetify-combined-playlists-dist"

Write-Host "Removing Better Library Github Dir"
Remove-Item -Recurse -Force "$env:APPDATA\spicetify\CustomApps\betterLibrary-main"

# Apply Spicetify configurations
Write-Host "Applying Spicetify configuration."
spicetify apply

# Install BlockTheSpot
Write-Host "Installing BlockTheSpot."
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/thororen1234/extra/refs/heads/main/BlockTheSpot.ps1' | Invoke-Expression

Write-Host "Script Finished."
Pause
