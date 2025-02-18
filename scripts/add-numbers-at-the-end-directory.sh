#!/bin/bash
#
# -- Bash script --
#  github: https://github.com/ekardian
#
#  Serialize files with Letter + numbers before the extension
#
#    From      To
#  +------+----------+
#  |dir-a | dir-a-F1 |
#  |dir-b | dir-b-F2 |
#  +------+----------+
#
# Try creating this directories and test the script:
#
# $ mkdir testing
# $ cd testing
# $ mkdir dir-{a..b}
#
# How to use
#
# Step 1
# Copy the script add-numbers-at-the-end-directory.sh
# to the directory where you want rename to serialize directories.
#
# Step 2
# $ chmod +x add-numbers-at-the-end-directory.sh
# $ ./add-numbers-at-the-end-directory.sh
#
echo ""
echo -e "\e[1;33m==========================================\e[0m"
echo -e "\e[1;33mWill be renamed the directory            \e[0m"
echo -e "\e[1;33mdirectory-(letter)(number increased)     \e[0m"
echo -e  "\e[1;33m==========================================\e[0m"
echo ""
echo -e "\e[1;33mInital letter for serial like (A,F,Doc,etc) or leave blank for write only numbers:\e[0m "; read -r letter
echo -e "\e[1;33mWhat number to start enumerating:\e[0m ";  read -r i
if [ "serial-files.txt" ]; then rm -f serial-files.txt -f; fi
for f in `find . -maxdepth 1 -type d -printf '%P\n'`
  do
    if [ "$f" = "add-numbers-at-the-end-directory.sh" ]
    then
      continue
    fi
     t=$((i++))
     mv -n -- "$f" "$f-$letter$t"
   echo "$letter$t" >> serial-files.txt
done
echo ""
echo -e "\e[1;33mRERMINADO\e[0m"
echo ""
echo -e "\e[1;33mJoin your serialized directories: $ cat serial-files.txt /other/serial-files.txt > all-files.txt\e[0m"
echo ""
