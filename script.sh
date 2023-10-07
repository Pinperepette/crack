#!/bin/bash

# Function to print the progress bar
function print_progress_bar {
    local ratio=$1
    local mark="#"
    local progress=$((ratio / 25))
    printf "Script loading: [%-${progress}s] %d%%\r" "$mark" "$ratio"
}

echo " "
ratio=0
while [ $ratio -le 100 ]
do
    print_progress_bar $ratio
    sleep 0.4
    ratio=$((ratio + 25))
done

# Get the current directory path
current_directory=$(pwd)

# Search for insert_dylib and libInlineInjectPlugin.dylib files in the Tools folder
insert_dylib_files=($current_directory/Tools/insert_dylib)
lib_inline_files=($current_directory/Tools/libInlineInjectPlugin.dylib)

# Check if the files are found and set the paths
if [[ ${#insert_dylib_files[@]} -gt 0 && ${#lib_inline_files[@]} -gt 0 ]]; then
    insert_dylib=${insert_dylib_files[0]}
    lib_inline=${lib_inline_files[0]}

    # Assign execution permissions to the files
    chmod +x "$insert_dylib"
    chmod +x "$lib_inline"

    # Request the application path
    read -p "Drag the application into the terminal: " mac_app

    # Find and modify files inside the application
    file_names=(
        "Announcements"
        "KMDrawViewSDK_Mac"
        "Sparkle"
        "PTHotKey"
        "XADMaster"
        "KissXML"
        "JSONModel"
        "NAVTabBarView"
        "GZIP"
        "ShortcutRecorder"
        "NektonyFallManager"
    )

    for file_name in "${file_names[@]}"
    do
        find_result=$(find "$mac_app" -name "$file_name" -type f)

        if [[ -n "$find_result" ]]; then
            cp -p "$find_result" "$find_result"_copia
            "$insert_dylib" "$lib_inline" "$find_result"_copia "$find_result"
        fi
    done

    # Remove the quarantine attribute from the application
    xattr -d com.apple.quarantine "$mac_app"

    echo " "
    echo "Removed quarantine attribute, App cracked successfully. (If Mac is M1 series or above, run with Rosetta)"
    echo "Cracked, Have a good time, Coccodio"
else
    echo "Insert_dylib or Lib_inline files not found. Please check the paths."
fi
