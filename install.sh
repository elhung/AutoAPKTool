#!/bin/bash
red=`tput setab 1`
white=`tput setaf 7`
green=`tput setab 2`
reset=`tput sgr0`
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
IFS='/' read -ra ADDR <<< "$SCRIPTPATH"
pts="$SCRIPTPATH/Files"
ptd="/Users/${ADDR[2]}"
ptd2="/usr/local/bin"
mv $pts/a.sh $ptd2
echo "${green}${white}Moved Main Script to $ptd2, run it by typing a.sh in Terminal${reset}"
mv $pts/signapk.jar $ptd
mv $pts/testkey.x509.pem $ptd
mv $pts/testkey.pk8 $ptd
mv $pts/AutoApkConfig.txt $ptd
echo "${green}${white}Moved Signing Files & Config.txt to /Users/${ADDR[2]}${reset}"
if hash apktool 2>/dev/null; then
    echo "${green}${white}Apktool is installed!${reset}"
else
  echo "${red}${white}Apktool is not installed! Should I install it for you?${reset}"
  select yn in "Yes" "No"; do
    case $yn in
        Yes ) mv $pts/apktool $ptd2
              mv $pts/apktool.jar $ptd2
              echo "${green}${white}Apktool Installed!${reset}"
              break;;
        No )  echo "${red}${white}:(${reset}"
              break;;
    esac
  done
fi
echo "${green}${white}Installation Complete!${reset}"
echo "${red}${white}Deleting Source Files in 3 Seconds!${reset}"
sleep 3
rm -rf $SCRIPTPATH
