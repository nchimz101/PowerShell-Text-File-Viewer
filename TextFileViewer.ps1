# File Viewer PowerShell Script

function Show-TextFiles {
    param (
        [Parameter(Mandatory=$true)]
        [string]$DirectoryPath
    )

    # Check if directory exists
    if (-not (Test-Path -Path $DirectoryPath -PathType Container)) {
        Write-Host "Error: Directory does not exist." -ForegroundColor Red
        return
    }

    # Get all text files in the directory
    $textFiles = Get-ChildItem -Path $DirectoryPath -Filter "*.txt"

    # Check if any text files were found
    if ($textFiles.Count -eq 0) {
        Write-Host "No text files found in the specified directory." -ForegroundColor Yellow
        return
    }

    # Display the list of text files with numbers
    Write-Host "`nText files in $DirectoryPath:" -ForegroundColor Cyan
    for ($i = 0; $i -lt $textFiles.Count; $i++) {
        Write-Host "[$($i+1)] $($textFiles[$i].Name)"
    }

    # Prompt the user to select a file
    $selection = Read-Host "`nEnter the number of the file you want to view (or 'q' to quit)"

    # Check if user wants to quit
    if ($selection -eq 'q') {
        return
    }

    # Validate user input
    try {
        $fileIndex = [int]$selection - 1
        if ($fileIndex -lt 0 -or $fileIndex -ge $textFiles.Count) {
            throw "Invalid selection"
        }

        $selectedFile = $textFiles[$fileIndex]
        
        # Display file contents
        Write-Host "`nContents of $($selectedFile.Name):" -ForegroundColor Green
        Write-Host "------------------------------------------------------" -ForegroundColor Green
        Get-Content -Path $selectedFile.FullName
        Write-Host "------------------------------------------------------" -ForegroundColor Green
    }
    catch {
        Write-Host "Invalid selection. Please enter a valid number." -ForegroundColor Red
    }
}

# Main script execution
$directoryPath = Read-Host "Enter the directory path to scan for text files"
Show-TextFiles -DirectoryPath $directoryPath
