#!/bin/bash
#
#  -- Script in Bash --
#
#  Script for extract streamns from mp4 container.
#
#    Copyright @ 2023-2024, BIOS Tech <bioswork@gmailcom>
#              @ 2024, Erwin Castedo <blkid@protonmail.com>
#
# --------------------------------------------------------------------
#
#  GNU AFFERO GENERAL PUBLIC LICENSE
#     Version 3, 19 November 2007
#
#  https://www.gnu.org/licenses/agpl-3.0.txt
#
#===============================================================================
#
#      What is this:
#
#          FILE: ccmp4extract.sh
#
#         USAGE: 
#                sudo cp -v ccmp4extract.sh /usr/local/bin
#                sudo chmod 755 /usr/local/bin/ccmp4extract.sh
#                ccmp4extract.sh file.mp4
#
#   DESCRIPTION: MP4 Containers have video, audio, substitles, chapters streams.
#                ccmp4extract.sh with few steps and automated options, you can
#                extract this streams
#
#  REQUIREMENTS: ffmpeg ffprobe (ffmpeg package)
#                egrep
#          BUGS: None 
#         NOTES: Compatible with Linux and Windows (Cygwin) 
#        AUTHOR: Erwin Castedo <blkid@protonmail.com>
#  ORGANIZATION: BIOS Tech <bioswork@gmail.com>
#       CREATED: 21/03/2025 21:00
#      REVISION: 1.0
#
#      DONATION: https://github.com/ekardian/dryncsnsx#donation
#
#===============================================================================
#
# Shortcuts
# Color
cin="\e[33m"
cout="\e[0m"

# Stream hass ben extracted
sok="echo -e ${cin}\n--------------------------------------------------\n  THE STREAM HAS B€EN EXTRACTED!!!\n--------------------------------------------------\n${cout}"

# Executing
running="echo -e ${cin}Extracting stream ...${cout}"

# License
license="echo -e ${cin}\n=========================================================\nThe use of this software is always at your own risk.\n
Licenced Under GPLv2.1\n
GNU Lesse General Public Licence, version 2.1\n
https://www.gnu.org/licenses/old-licenses/lgpl-2.1.html\n=========================================================\n${cout}"

# Error's
erro="echo -e ${cin}\nERROR!!! Execute in this way: ccmp4extract.sh file.mp4\n${cout}"

# Donation 
donation="echo -e ${cin}\nDonation\nhttps://github.com/ekardian/dryncsnsx#donation\n${cout}"

if [[ -f "$1" ]]; then
  echo -e "${cin}-- Script for extract streams with ffmpeg from mp4 files --${cout}"
  echo -e "${cin}----------------------------------------------${cout}"
  echo -e "${cin}ffmpeg information from '$1'${cout}"

  # examples ffprobe
  #ffprobe -log-level -0 -print_format json -show_format -show_streams "$1" > "$1"-ffprobe.json
  #ffprobe -hide_banner -loglevel fatal -show_error -show_format -show_streams -show_programs -show_chapters -show_private_data -print_format json <input-file.{mp3,mp4,mkv,avi}
  
  ffprobe -v quiet -print_format json -show_format -show_streams "$1" > "$1"-ffprobe.json
  egrep --color -w 'index|codec_name|codec_long_name|codec_type|codec_tag_string|language' "$1"-ffprobe.json
  echo -e "${cin}try 'ffprobe -v quiet -print_format json -show_format -show_streams file.mp4 > output.json' for more information ${cout}"
  echo -e "${cin}----------------------------------------------${cout}"

# function echo
display1() {
  echo -e "${cin}${ans1}${cout}"
}
display2() {
  echo -e "${cin}${ans2}${cout}"
}
display3() {
  echo -e "${cin}${ans3}${cout}"
}
displaytips() {
  echo -e "${cin}${tips}${cout}"
}

  PS3="Choice a option (see media streams with ffpobe): "
  options=("1 audio stream" "2 video stream" "3 subtitles" "4 about" "5 exit")
  select opt in "${options[@]}"
  do
    case $opt in
      "1 audio stream")
        ans1="Choice audio stream, ex. (0:3): "
        display1 $ans1
        read -rp "" astream

        ans2="Choice extension stream, ex. (aac, ac3): "
        display2 $ans2
        read -rp "" extstream

        ans3="Choice language stream, ex (en, es): "
        display3 $ans3
        read -rp "" lengua

        $running
        ffmpeg -i "$1" -map "$astream" -c copy "$1"-"$lengua"."$extstream"
        $sok

        echo -e "${cin}Detect Volume? from $1 , (y/n): ${cout}"; read -r yn
        if [[ "$yn" =~ ^[Yy]$  ]]; then
          echo -e "${cin}Detecting Volume for normalize ....${cout}"
          ffmpeg -i "$1"-"$lengua"."$extstream" -af "volumedetect" -f null /dev/null
          $sok
          echo -e "${cin}Now normalize, example ffmpeg -i file.aac -af "volume=1.5dB" -c:a aac -b:a 128k new-audio-file.aac${cout}"

          echo -e "${cin}Normalize Volume? (y/n): ${cout}"; read -r yn
          if [[ "$yn" =~ ^[Yy]$  ]]; then
            echo -e "${cin}Check max_volume for normalize, if -1.8db, then write 1.8dB: ${cout}"; read -r nvol
            echo -e "${cin}Audio Codec, ex. (aac, libmp3lame): ${cout}"; read -r cdstream
            echo -e "${cin}Bitrate Audio, ex. (128k): ${cout}"; read -r btstream

            ffmpeg -i "$1"-"$lengua"."$extstream" -af "volume=${nvol}" -c:a "$cdstream" -b:a "$btstream" "$1"-"$lengua"-"$cdstream"-"$btstream"."$extstream"

            echo -e "${cin}Done!!! Audio extracted and normalized.${cout}"
            $sok
            exit
          else
            echo -e "${cin}Done!!!.${cout}"
            $sok
            exit
          fi
        else
          echo -e "${cin}Done!!!.${cout}"
          $sok
          exit
        fi
        exit
      ;;
      "2 video stream")
        ans1="Choice video stream, ex. Usually (0:0): "
        display1 $ans1
        read -rp "" vstream

        ans2="Choice video extension, ex. (h264/mp4, h265/mp4): "
        display2 $ans2
        read -rp "" evstream
        
        $running
        ffmpeg -i "$1" -map "$vstream" -c copy "$1"."$evstream"
        $sok
        exit
      ;;
      "3 subtitles")
        ans1="Choice subtitle stream, ex.(0:4): "
        display1 $ans1
        read -rp "" sstream

        tips="if codec_tag_string/mov_text is tx3g, after converted export to SubRip(srt) with https://subtitletools.com/convert-to-srt-online - a tx3g file have <font><i> tags format"
        displaytips
        echo ""
        ans2="Choice subtitle extension, this will be converted automatically, ex.(srt): "
        display2 $ans2
        read -rp "" esstream
        
        $running
        ffmpeg -i "$1" -map "$sstream" "$1"."$esstream"
        $sok

        tips="if codec_tag_string/mov_text is tx3g, after converted export to SubRip(srt) with https://subtitletools.com/convert-to-srt-online - a tx3g file have <font><i> tags format"
        displaytips
        echo ""
        exit
      ;;
      "4 about")
        $license
        exit
      ;;
      "5 exit")
        $donation
        echo -e "${cin}Script Exited!.${cout}"
        exit
      ;;
      *)
        echo "${cin}Invalid options $REPLY, Press CTRL+C for exit.${cout}"
      ;;
    esac
  done
# extract and check the volume stream for normalization needs
else
  $erro
  read -rp "Press Enter for exit ..."
  exit
fi
