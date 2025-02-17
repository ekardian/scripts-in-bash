#!/bin/bash
#
# -- Bash script --
# github: https://github.com/ekardian
#
# Extract letters and strings after the last symbol '-' and before extension file
#
# From my-file-F1234.txt -> F1234
#
# The output F1234 is saved in the file outfile.txt in the same directory where the script was executed
#
# 
echo ""
echo -e "\e[1;33m video-F1234.mp4 -> extract F1234\e[0m"
echo -e "\e[1;33m Mi-Archivo-A234.mp3 -> extract A234 \e[0m"
echo ""
echo "Filter Extension without pattern, example: mp4 : "; read -r ext
echo ""
ls -1 *."$ext" > list
sed -e 's/^.*\-\(.*\)\.\(.*\)/\1/' list > outfile.txt
echo ""
echo -e "The result was saved in the file outfile.txt"
echo ""
cat outfile.txt
echo ""
echo -e "\e[1;33mTERMINADO\e[0m"
echo ""



