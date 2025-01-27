#!/bin/bash
#
# -- Bash script --
#
# github: https://github.com/ekardian/scripts-in-bash
#
#  Serialize files with Letter + number at begining of the files like
#
#  from:
#  file-a.txt
#  file-b.txt
#
#
#  F1_file-a.txt
#  F2_file-b.txt
#
# How to use
#
# Copy the script serialize-files.sh to the dir
# where you want rename/serialize files
#
# $ chmod +x serialize-files.sh
# $ ./serializa-files.sh
#
#
#
echo ""
echo "CAUTION!!!"
echo "THIS SCRIPT GONNA RENAME YOUR FILE, BACKUP YOUR FILES BEFORE"
echo ""
echo "Will be renamed from FILE.extension to FILE-(Your suffix)(number increased).extension"
echo ""
echo -e "Inital letter for serial like (A,F,Doc,etc) or leave blank for write only numbers: "; read -r letter
i=0
for file in ./*; do
  ext=${file##*.}
  basename=${file%.*}
  mv -n -- "$file" "$basename-$letter$i.$ext"
  i=$((i+1))
done
echo ""
echo "RERMINADO"
echo ""
