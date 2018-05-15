#!/usr/bin/env bash
#file="/etc/apt/apt.conf"
dirs=("/usr/share/doc/apt/examples/apt.conf" "/etc/apt" "/etc/apt/apt.conf")
proto=( "http" "https" "ftp")
proxy=10.0.67.28
port=3128

if [ -f "${dirs[2]}" ]
then
        echo "${dirs[2]} found."
        for p in "${proto[@]}"; do
        printf 'Acquire::%s::proxy "%s://%s:%u";\n' "$p" "$p" "$proxy" "$port"
                done | sudo tee -a ${dirs[2]} > /dev/null
                echo "Setup done."
else
        echo "${dirs[2]} not found."
        echo "Adding file."
        cp ${dirs[0]} ${dirs[1]}
        for p in "${proto[@]}"; do
        printf 'Acquire::%s::proxy "%s://%s:%u";\n' "$p" "$p" "$proxy" "$port"
                done | sudo tee -a ${dirs[2]} > /dev/null
                echo "Setup done."
fi
