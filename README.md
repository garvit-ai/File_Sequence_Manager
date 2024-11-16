# File_Sequence_Manager

This PowerShell script helps manage and organize files in a directory by renaming them with updated numeric prefixes based on their new positions in a sequence. The script is particularly useful for programming projects, where files are named with numeric prefixes (e.g., 01_intro.cpp, 02_example.cpp), and you want to reorder them while maintaining proper sequence numbering.

Features
Automatically renames files to maintain sequential numbering.
Supports moving a file to a higher or lower position in the sequence.
Recursively searches through the specified directory and subdirectories for the target file.
Provides clear debugging output for tracking renaming operations.

How It Works
Input Parameters:

fileName: The name of the file you want to move (e.g., 02_pointer_example.cpp).
position: The new position number for the file (e.g., 5 to move the file to position 5).
