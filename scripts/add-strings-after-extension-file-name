#!/bin/bash
# Requirement: rename
# install: sudo apt install rename

echo -e "\e[1;33m Search path dir: \e[0m"; read -r dirclips
echo -e "\e[1;33m Search original file: \e[0m"; read -r item
echo -e "\e[1;33m Letters to add (i.e. A1): \e[0m"; read -r iditem
c="$iditem"
export c
cd -- "$(dirname "$(find "$dirclips" -type f -name "$item" | head -1)")"
if [ -f "$item" ]; then
        rename 's/(.+)\.(.+)/$1-\Q$ENV{c}\E.$2/' "$item"
        echo -e "\e[1;33m Done, added: -$iditem  to file: $item"
else
        echo -e "\e[1;33m File doesn't exist: \e[0m $item"
fi

# DONATION
# --------
# Works for you? grate!!!! You can give me a donation via Wester Union, thanks XD
#
# - Name: Erwin Marcell Alayn
# - Last Name: Castedo Plantarrosa
# - City/Country: Yacuiba, Departamento de Tarija, Bolivia
# - Notify me by email : blkid@protonmail.com
#
# Te sirvió algún script? genial!!!  Sin compromisos me podrías invitar un tecito enviándome una donación (5$ dólares americanos) por Western Union.
