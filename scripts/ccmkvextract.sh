#!/bin/bash
#
#  -- Script in Bash --
#
#  Dryncs, Copy files serialized from local pc or remote pc.
#
#    Copyright @ 2024-2025, BIOS Tech <bioswork@gmail.com>
#              @ 2024, Erwin Castedo <blkid@protonmail.com>
#
# ------------------------------------------------------------------
#     GNU General Public License, version 2
# https://www.gnu.org/licenses/old-licenses/gpl-2.0.html
# ------------------------------------------------------------------
#
#      What is this:
#
#          FILE: ccmkvextract.sh
#
#         USAGE:          
#               sudo cp -v ccmkvextract.sh /usr/local/bin
#               sudo chmod 755 /usr/local/bin/ccmkvextract.sh
#               ccmkvextract.sh file.mkv
# 
#   DESCRIPTION: Extract tracks from mkv file with mkvextract command
#                Video, Audios, Subtitles, Chapters, Tags, Timestamps
#
#  REQUIREMENTS: mkvextract mkvmerge mkvmerge (mkvtoolnix package)
#i         BUGS: None
#         NOTES: Run for Linux and Windows (cygwin)
#        AUTHOR: Erwin Castedo <blkid@protonmail.com>
#  ORGANIZATION: BIOS Tech <bioswork@gmail.com>
#       CREATED: 19/03/2025 04:25
#      REVISION: 1.0
#
#      DONATION: https://github.com/ekardian/dryncsnsx#donation
#
#---------------------------------------------------------
#     GNU General Public License, version 2
# https://www.gnu.org/licenses/old-licenses/gpl-2.0.html
#---------------------------------------------------------
#
cin="\e[33m"
cout="\e[0m"
if [[ -f "$1" ]]; then
  echo -e "${cin}-- Script for extract tracks from mkv files --${cout}"
  echo -e "${cin}----------------------------------------------${cout}"
  echo -e "${cin}mkvmerge information from '$1'${cout}"
  mkvmerge -i "$1"
  echo -e "${cin}Try 'mkvinfo mkv.file' for more information${cout}"
  echo -e "${cin}----------------------------------------------${cout}"
  PS3='Choice a option (see mkv tracks with mkvinfo and mkvmerge): '
  options=("1 audio track" "2 audio tracks" "3 audio tracks" "4 manual audio track" "5 video track" "6 subtitles track" "7 chapters tags timestamps_v2" "8 About"  "9 exit")
  select opt in "${options[@]}"
  do
    case $opt in
      "1 audio track")
        echo -e "${cin}Extension from Audio Track #1 (aac, ac3, dts);${cout} "; read -r ext
        echo -e "${cin}Language from Audio Track #1 (en , es, etc.);${cout} "; read -r lengua
        echo -e "${cin}Extracting audio track #1...${cout}"
        mkvextract "$1" tracks 1:"$1"-track-1_"$lengua"."$ext"
        echo -e "${cin}THE AUDIO TRACK HAS BEEN EXTRACTED!!!${cout}"
        exit
      ;;
      "2 audio tracks")
        echo -e "${cin}Extension from Audio Track #1 (aac, ac3, dts);${cout} "; read -r ext
        echo -e "${cin}Language from Audio Track #1 (en , es, etc.);${cout} "; read -r lengua
        echo -e "${cin}Extension from Audio Track #2 (aac, ac3, dts);${cout} "; read -r ext2
        echo -e "${cin}Language from Audio Track #2 (en , es, etc.);${cout} "; read -r lengua2
        echo -e "${cin}Extracting audio track #1, track #2...${cout}"
        mkvextract "$1" tracks 1:"$1"-track-1_"$lengua"."$ext"
        mkvextract "$1" tracks 2:"$1"-track-2_"$lengua2"."$ext2"
        echo -e "${cin}THE AUDIO TRACKS HAS BEEN EXTRACTED!!!${cout}"
        exit
      ;;
      "3 audio tracks")
        echo -e "${cin}Extension from Audio Track #1 (aac, ac3, dts);${cout} "; read -r ext
        echo -e "${cin}Language from Audio Track #1 (en , es, etc.);${cout} "; read -r lengua
        echo -e "${cin}Extension from Audio Track #2 (aac, ac3, dts);${cout} "; read -r ext2
        echo -e "${cin}Language from Audio Track #2 (en , es, etc.);${cout} "; read -r lengua2
        echo -e "${cin}Extension for Audio Track #3 (aac, ac3, dts);${cout} "; read -r ext3
        echo -e "${cin}Language from Audio Track #3 (en , es, etc.);${cout} "; read -r lengua3
        echo -e "${cin}Extracting audio track #1, track #2, track #3...${cout}"
        mkvextract "$1" tracks 1:"$1"-track-1_"$lengua"."$ext"
        mkvextract "$1" tracks 2:"$1"-track-2_"$lengua2"."$ext2"
        mkvextract "$1" tracks 3:"$1"-track-3_"$lengua3"."$ext3"
        echo -e "${cin}THE AUDIO TRACKS HAS BEEN EXTRACTED!!!${cout}"
        exit
      ;;
      "4 manual audio track")
        echo -e "${cin}Choice the number audio track:${cout} "; read -r ntrack
        echo -e "${cin}Choice the extension aucio track(aac,ac3,dtc,etc):${cout} "; read -r ext
        echo -e "${cin}Language from Audio Track #3 (en , es, etc.);${cout} "; read -r lengua
        echo -e "${cin}Extracting audio track #1, track #2, track #3...${cout}"
        mkvextract "$1" tracks "$ntrack":"$1"-track"$ntrack"_"$lengua"."$ext"
        echo -e "${cin}THE AUDIO TRACK HAS BEEN EXTRACTED!!!${cout}"
        exit
      ;;
      "5 video track")
        # video container support for video coding formats
        # https://en.wikipedia.org/wiki/Comparison_of_video_container_formats
        echo -e "${cin}Choice the video track extension (h264-h265/MP4-AVI):${cout} "; read -r vext
        echo -e "${cin}Extracting video track...${cout}"
        mkvextract "$1" tracks 0:"$1"-video-track."$vext"
        echo -e "${cin}THE VIDEO TRACK HAS BEEN EXTRACTED!!!${cout}"
        exit
      ;;
      "6 subtitles track")
        echo -e "${cin}Choice the subtitle track number:${cout} "; read -r ntrack
        echo -e "${cin}Choice the subtitle track extension (srt, idx, etc):${cout} "; read -r sext
        echo -e "${cin}Language from subtitle Track (en, es, etc.);${cout} "; read -r lengua
        echo -e "${cin}Extracting subtitle track...${cout}"
        mkvextract "$1" tracks "$ntrack":"$1"-subtitle-track-"$ntrack"-"$lengua"."$sext"
        echo ""
        echo -e "${cin}------------------------------------------------------${cout}"
        echo -e "${cin}If there are wrong characters in extracted subs, try example:${cout}"
        echo -e "${cin}file -bi file.srt -> ouput: ISO-8859-1, to convert to  utf8 use iconv${cout}"
        echo -e "${cin}examplo: iconv -f ISO-8859-1 -t utf8 file.srt -o new-file.srt${cout}"
        echo -e "${cin}------------------------------------------------------${cout}"
        echo ""
        echo -e "${cin}THE VIDEO TRACK HAS BEEN EXTRACTED!!!${cout}"
        exit
      ;;
      "7 chapters tags timestamps_v2")
        echo -e "${cin}Generating Chapters tags timestamps_v2 ...${cout} "
        mkvextract "$1" timestamps_v2 0:tempo.video."$1".txt chapters chapters."$1".xml tags tags."$1".xml
        echo -e "${cin}THE VIDEO TRACK CHAPTERS TAGS TIMESTAPMS HAS BEEN EXTRACTED!!!${cout}"
        exit
      ;;
      "8 About")
        echo -e "${cin}============================================${cout}"
        echo ""
        echo -e "${cin}The use of this software is always at your own risk.\n
Licenced Under GPLv2\n
GNU General Public License, version 2
https://www.gnu.org/licenses/old-licenses/gpl-2.0.html${cout}"
        echo ""
        echo -e "${cin}============================================${cout}"
        exit
      ;;
      "9 exit")
        echo ""
        echo -e "${cin}Donation${cout}"
        echo -e "${cin}https://github.com/ekardian/dryncsnsx#donation ${cout}"
        echo ""
        echo -e "${cin}Script Exited!.${cout}"

        exit
      ;;
      *)
        echo "${cin}Invalid options $REPLY, Press CTRL+C for exit.${cout}"
      ;;
    esac
  done
else
  echo ""
  echo -e "${cin}ERROR!!! Execute in this way: ./ccmkvextract.sh file.mkv${cout}"
  echo ""
  read -rp "Press Enter for exit..."
  exit
fi
