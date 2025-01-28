#!/bin/bash
#
# -- Bash script --
#  github: https://github.com/ekardian
#
#  Serialize files with Letter + numbers before the extension
#
#      From           To
#  +-----------+---------------+
#  |file-a.txt | file-a-F1.txt |
#  |file-b.txt | file-b-F2.txt |
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
# Copy the script add-numbers-before-extension.sh
# to the directory where you want rename to serialize files.
#
# Step 2
# $ chmod +x add-numbers-before-extension.sh
# $ ./add-numbers-before-extension.sh
#
echo ""
echo -e "\e[1;33m==========================================\e[0m"
echo -e "\e[1;33mWill be renamed from FILE.extension to\e[0m"
echo -e "\e[1;33mFILE-(letter)(number increased).extension\e[0m"
echo -e  "\e[1;33m==========================================\e[0m"
echo ""
echo -e "\e[1;33mInital letter for serial like (A,F,Doc,etc) or leave blank for write only numbers:\e[0m "; read -r letter
echo -e "\e[1;33mWhat number to start enumerating:\e[0m ";  read -r i 
for f in *
  do
    if [ "$f" = "add-numbers-before-extension.sh" ]
    then
      continue
    fi
    ext=${f##*.}
    basename=${f%.*}
    mv -n -- "$f" "$basename-$letter$((i++)).$ext"
done
echo ""
echo -e "\e[1;33mRERMINADO\e[0m"
echo ""
