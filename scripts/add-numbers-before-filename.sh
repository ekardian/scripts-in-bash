#!/bin/bash
#
# -- Bash script --
#  github: https://github.com/ekardian
#
#  Serialize files with Letter + numbers before the file name
#
#      From           To
#  +-----------+---------------+
#  |file-a.txt | F1-file-a.txt |
#  |file-b.txt | F1-file-b.txt |
#  +-----------+---------------+
#
# Try creating this files and test the script:
#
# $ mkdir testing
# $ cd testing
# $ touch file-{a..b}.txt
#
# How to use
#
# Step 1
# Copy the script add-numbers-before-filename.sh
# to the directory where you want rename to serialize files.
#
# Step 2
# $ chmod +x add-numbers-before-filename.sh
# $ ./add-numbers-before-filenam.sh
#
echo ""
echo -e "\e[1;33m==========================================\e[0m"
echo -e "\e[1;33mWill be renamed from FILE.extension to\e[0m"
echo -e "\e[1;33m(letter)(number increased)-FILE.extension\e[0m"
echo -e  "\e[1;33m==========================================\e[0m"
echo ""
echo -e "\e[1;33mA Letter for description, example (F, A, Doc, Video, etc ), just enter for leave empty:\e[0m" ; read -r letter
echo -e "\e[1;33mWhat number to start enumerating:\e[0m"; read -r i
for f in *
  do
    if [ "$f" = "add-numbers-before-filename.sh" ]
    then
      continue
    fi
    mv "$f" "$letter$((i++))_$f"
done
echo ""
echo -e "\e[1;33mTERMINADO\e[0m"
echo ""

