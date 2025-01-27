#!/bin/bash
#
# -- Bash script --
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
echo -e "A Letter for description, example (F, A, Doc, Video, etc ), just enter for leave empty: "; read -r letter
n=1
for f in *
  do
    if [ "$f" = "serialize-files-README-BEFORE-TO-USE.sh" ]
    then
      continue
    fi
    mv "$f" "$letter$((n++))_$f"
done
echo ""
echo "TERMINADO"
echo ""

