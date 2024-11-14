param(
    [string]$fileName,  # The name of the file to move, e.g., '02_pointer_example.cpp'
    [int]$position      # The new position number for the file
)

# Define the working directory where the files are located
$directoryPath = "C:\Users\garrv\OneDrive\Desktop\Coding_Workspace\Cpp_Workspace"

# Change to the directory
Set-Location $directoryPath

# Debugging output to verify location and files present
Write-Output "Current Directory: $(Get-Location)"
Write-Output "Files in Current Directory and Subdirectories:"
Get-ChildItem -Recurse -Filter "*.cpp" | ForEach-Object { $_.FullName }

# Find the full path to the file
$fileFullPath = Get-ChildItem -Recurse -Filter "*.cpp" | Where-Object { $_.Name -eq $fileName } | Select-Object -ExpandProperty FullName

# Ensure that the file exists in the directory or subdirectories
if (-not $fileFullPath) {
    Write-Error "The file '$fileName' does not exist in the specified directory or its subdirectories."
    exit
}

# Extract the current number from the filename
$currentNumber = [int]($fileName -split '_')[0]

# Determine the direction of the shift and process files
if ($currentNumber -lt $position) {
    # Moving a file to a higher number
    $files = Get-ChildItem -Recurse -Filter "*.cpp" |
             Where-Object { [int](($_.Name -split '_')[0]) -gt $currentNumber -and
                            [int](($_.Name -split '_')[0]) -le $position } |
             Sort-Object Name

    foreach ($file in $files) {
        $number = [int]($file.Name -split '_')[0]
        $newFileNumber = "{0:D2}" -f ($number - 1)
        $remainingName = ($file.Name -split '_', 2)[1]
        $newName = "$newFileNumber`_$remainingName"

        # Debugging output
        Write-Output "Renaming '$($file.FullName)' to '$newName'"

        Rename-Item -Path $file.FullName -NewName $newName
    }
} else {
    # Moving a file to a lower number
    $files = Get-ChildItem -Recurse -Filter "*.cpp" |
             Where-Object { [int](($_.Name -split '_')[0]) -lt $currentNumber -and
                            [int](($_.Name -split '_')[0]) -ge $position } |
             Sort-Object Name -Descending

    foreach ($file in $files) {
        $number = [int]($file.Name -split '_')[0]
        $newFileNumber = "{0:D2}" -f ($number + 1)
        $remainingName = ($file.Name -split '_', 2)[1]
        $newName = "$newFileNumber`_$remainingName"

        # Debugging output
        Write-Output "Renaming '$($file.FullName)' to '$newName'"

        Rename-Item -Path $file.FullName -NewName $newName
    }
}

# Rename the target file to the new position
$newFileNumber = "{0:D2}" -f $position
$remainingName = ($fileName -split '_', 2)[1]
$newFileName = "$newFileNumber`_$remainingName"

# Debugging output for renaming the target file
Write-Output "Renaming '$fileFullPath' to '$newFileName'"

# Only rename if the new file name is not empty and different from the original
if (-not [string]::IsNullOrWhiteSpace($newFileName) -and $newFileName -ne $fileName) {
    Rename-Item -Path $fileFullPath -NewName $newFileName
} else {
    Write-Error "Failed to rename '$fileName' to '$newFileName'. The new file name is invalid."
}
