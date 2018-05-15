#!/bin/bash
distro="stretch"
dis_type="main"

loc=("deb http://deb.debian.org/debian/ $distro $dis_type" "deb http://security.debian.org/debian-security $distro/updates $dis_type")
file="/etc/apt/sources.list"

if [ -f "$file" ]
then
        echo "File $file already exists!"
        echo "Creating backup."
        mv "$file" "$file"_BAK
        echo "Creating new $1"
        for p in "${loc[@]}"; do
                echo "$p" >> "$file"
                done
                echo "$file created"
else
        echo "File $file does not exists!"
        echo "Creating new $1"
        for p in "${loc[@]}"; do
                echo "$p" >> "$file"
                done
                echo "$file created 1"
fi
