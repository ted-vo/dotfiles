#!/usr/bin/env bash

local desktop="
"

cat >app.desktop <<EOF
[Desktop Entry]
Type=Application
Version=1.0
Name=jMemorize
Comment=Flash card based learning tool
Path=/opt/jmemorise
Exec=jmemorize
Icon=jmemorize
Terminal=false
Categories=Education;Languages;Java
EOF

desktop-file-validate app.desktop

desktop-file-install app.desktop
