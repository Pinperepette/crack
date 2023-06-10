#!/usr/bin/env python
import os
import subprocess
import time
import glob

def print_progress_bar(ratio):
    mark = '#' * (ratio // 25)
    print(f"Script loading: [{mark:<24}] {ratio}%")

print(" ")
for ratio in range(0, 101, 25):
    time.sleep(0.4)
    print_progress_bar(ratio)

home = os.path.expanduser('~')
insert_dylib_files = glob.glob(home + '/**/insert_dylib', recursive=True)
lib_inline_files = glob.glob(home + '/**/libInlineInjectPlugin.dylib', recursive=True)

insert_dylib = insert_dylib_files[0] if insert_dylib_files else ""
lib_inline = lib_inline_files[0] if lib_inline_files else ""

# Give execution permissions
subprocess.run(['sudo', 'chmod', '+x', insert_dylib], check=True)
subprocess.run(['sudo', 'chmod', '+x', lib_inline], check=True)

mac_app = input("Drag the application into the terminal: ")

file_names = [
    "Announcements",
    "KMDrawViewSDK_Mac",
    "Sparkle",
    "PTHotKey",
    "XADMaster",
    "KissXML",
    "JSONModel",
    "NAVTabBarView",
    "GZIP",
    "ShortcutRecorder",
    "NektonyFallManager",
]

for file_name in file_names:
    find_command = ['find', mac_app, '-name', file_name, '-type', 'f']
    find_result = subprocess.run(find_command, capture_output=True, text=True).stdout.strip()

    if find_result:
        subprocess.run(['sudo', 'cp', '-p', find_result, find_result + '_copia'], check=True)
        subprocess.run(['sudo', insert_dylib, lib_inline, find_result + '_copia', find_result], check=True)

subprocess.run(['sudo', 'xattr', '-d', 'com.apple.quarantine', mac_app], check=True)
print(" ")
print("Removed quarantine attribute, App cracked successfully. (If Mac is M1 series or above, run with Rosetta)\n")
print("Cracked, Have a good time. by hoochanlon. \n")
