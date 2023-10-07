#!/bin/bash

# Funzione per stampare la barra di avanzamento
function print_progress_bar {
    local ratio=$1
    local mark="#"
    local progress=$((ratio / 25))
    printf "Script loading: [%-${progress}s] %d%%\r" "$mark" "$ratio"
}

echo " "
for ratio in {0..100..25}
do
    print_progress_bar $ratio
    sleep 0.4
done

# Ottieni il percorso corrente
current_directory=$(pwd)

# Cerca i file insert_dylib e libInlineInjectPlugin.dylib nella cartella Tools
insert_dylib_files=($current_directory/Tools/insert_dylib)
lib_inline_files=($current_directory/Tools/libInlineInjectPlugin.dylib)

echo " "
echo "Insert_dylib files found:"
echo "${insert_dylib_files[@]}"
echo " "
echo "Lib_inline files found:"
echo "${lib_inline_files[@]}"

# Controlla se i file sono stati trovati e imposta i percorsi
if [[ ${#insert_dylib_files[@]} -gt 0 && ${#lib_inline_files[@]} -gt 0 ]]; then
    insert_dylib=${insert_dylib_files[0]}
    lib_inline=${lib_inline_files[0]}

    echo "insert_dylib path: $insert_dylib"
    echo "lib_inline path: $lib_inline"

    # Assegna i permessi di esecuzione ai file
    chmod +x "$insert_dylib"
    chmod +x "$lib_inline"

    # Richiedi l'applicazione
    read -p "Drag the application into the terminal: " mac_app

    # Trova e modifica i file all'interno dell'applicazione
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

    # Rimuovi l'attributo di quarantena dall'applicazione
    xattr -d com.apple.quarantine "$mac_app"

    echo " "
    echo "Removed quarantine attribute, App cracked successfully. (If Mac is M1 series or above, run with Rosetta)"
    echo "Cracked, Have a good time. by hoochanlon."
else
    echo "Insert_dylib or Lib_inline files not found. Please check the paths."
fi
