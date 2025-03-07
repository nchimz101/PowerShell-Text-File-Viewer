# File Manager PowerShell Script

function Create-Directory {
    param (
        [Parameter(Mandatory=$true)]
        [string]$DirectoryPath
    )
    
    # Check if directory exists, create if it doesn't
    if (-not (Test-Path -Path $DirectoryPath -PathType Container)) {
        try {
            New-Item -Path $DirectoryPath -ItemType Directory -Force | Out-Null
            Write-Host "Directory created: $DirectoryPath" -ForegroundColor Green
        }
        catch {
            Write-Host "Error creating directory: $_" -ForegroundColor Red
            return $false
        }
    }
    else {
        Write-Host "Directory already exists: $DirectoryPath" -ForegroundColor Yellow
    }
    
    return $true
}

function Create-SampleFiles {
    param (
        [Parameter(Mandatory=$true)]
        [string]$DirectoryPath
    )
    
    $files = @(
        @{
            Name = "file1.txt"
            Content = "This is the first sample file.`nIt contains multiple lines of text.`nCreated on $(Get-Date)"
        },
        @{
            Name = "file2.txt"
            Content = "This is the second sample file.`nIt has different content than the first file.`nCreated on $(Get-Date)"
        },
        @{
            Name = "file3.txt"
            Content = "This is the third sample file.`nJust another example of file content.`nCreated on $(Get-Date)"
        }
    )
    
    foreach ($file in $files) {
        $filePath = Join-Path -Path $DirectoryPath -ChildPath $file.Name
        try {
            Set-Content -Path $filePath -Value $file.Content
            Write-Host "File created: $filePath" -ForegroundColor Green
        }
        catch {
            Write-Host "Error creating file $($file.Name): $_" -ForegroundColor Red
        }
    }
}

function List-Files {
    param (
        [Parameter(Mandatory=$true)]
        [string]$DirectoryPath
    )
    
    Write-Host "`nFiles in directory $DirectoryPath:" -ForegroundColor Cyan
    Write-Host "------------------------------------------------------" -ForegroundColor Cyan
    
    $files = Get-ChildItem -Path $DirectoryPath -File
    
    if ($files.Count -eq 0) {
        Write-Host "No files found in the directory." -ForegroundColor Yellow
    }
    else {
        foreach ($file in $files) {
            $sizeInKB = [math]::Round($file.Length / 1KB, 2)
            Write-Host "$($file.Name) - $sizeInKB KB"
        }
    }
    
    Write-Host "------------------------------------------------------" -ForegroundColor Cyan
}

function Delete-File {
    param (
        [Parameter(Mandatory=$true)]
        [string]$DirectoryPath
    )
    
    $fileName = Read-Host "Enter the name of the file to delete"
    $filePath = Join-Path -Path $DirectoryPath -ChildPath $fileName
    
    if (Test-Path -Path $filePath -PathType Leaf) {
        try {
            Remove-Item -Path $filePath -Force
            Write-Host "File deleted: $filePath" -ForegroundColor Green
        }
        catch {
            Write-Host "Error deleting file: $_" -ForegroundColor Red
        }
    }
    else {
        Write-Host "File not found: $filePath" -ForegroundColor Red
    }
}

# Main script execution
Write-Host "PowerShell File Manager" -ForegroundColor Magenta
Write-Host "======================" -ForegroundColor Magenta

# Ask for directory path
$directoryPath = Read-Host "Enter a directory path to create or use"

# Create directory
$directoryCreated = Create-Directory -DirectoryPath $directoryPath

if ($directoryCreated) {
    # Create sample files
    Create-SampleFiles -DirectoryPath $directoryPath
    
    # List files
    List-Files -DirectoryPath $directoryPath
    
    # Delete a file
    Delete-File -DirectoryPath $directoryPath
    
    # List files again after deletion
    List-Files -DirectoryPath $directoryPath
}
