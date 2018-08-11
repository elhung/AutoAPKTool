#!/bin/bash
red=`tput setab 1`
white=`tput setaf 7`
green=`tput setab 2`
reset=`tput sgr0`
read -e -p "Function[d, b, s, p, help]: " fun
if [ "$fun" == "help" ]; then
  printf "Command List:\nd - Decompiles an APK [Provide any APK]\nb - Builds an APK [Provide Decompiled Folder]\ns - Signs an APK [Provide any APK]\np - Builds & Signs and APK [Provide Decompiled Folder]\n"
  sleep 3
  a.sh
else
  read -e -p "File: " file
  if [ $fun == "s" ] || [ $fun == "b" ] || [ $fun == "d" ] || [ $fun == "p" ] ; then
    if [ $fun == "s" ]; then
      read -e -p "OutputName: " name
      echo "${green}${white}Now Signing!${reset}"
      java -jar signapk.jar testkey.x509.pem testkey.pk8 $file $name
      echo "${green}${white}Signing Successfull${reset}"
    elif [ $fun == "d" ]; then
      IFS='/' read -ra ADDR <<< "$file"
      tbr=".apk"
      dir="/${ADDR[1]}/${ADDR[2]}/${ADDR[${#ADDR[@]} - 1]}"
      fdir="${dir//$tbr/}"
      if [ -d "$fdir" ]; then
        fun="d -f"
      fi
      if [ "$fun" == "d" ]; then
        echo "${green}${white}Now Decompiling!${reset}"
      fi
      if [ "$fun" == "d -f" ]; then
        echo "${green}${white}Now Force Decompiling!${reset}"
      fi
      apktool $fun $file
      if [ "$fun" == "d" ]; then
        echo "${green}${white}Decompiling Successfull!${reset}"
      fi
      if [ "$fun" == "d -f" ]; then
        echo "${green}${white}Force Decompiling Successfull!${reset}"
      fi
    elif [ $fun == "p" ]; then
      dist="/dist/"
      IFS='/' read -ra ADDR <<< "$file"
      filename=${ADDR[${#ADDR[@]} - 1]}
      ext=".apk"
      final=$file$dist$filename$ext
      read -e -p "OutputName[No need to add .apk]: " name2
      echo "${green}${white}Now Building!${reset}"
      apktool b $file
      echo "${green}${white}Building Successfull!${reset}"
      echo "${green}${white}Now Signing!${reset}"
      java -jar signapk.jar testkey.x509.pem testkey.pk8 $final $name2$ext
      echo "${green}${white}Signing Successfull!${reset}"
    else

        echo "${green}${white}Now Building!${reset}"

        apktool b $file

        echo "${green}${white}Building Successfull!${reset}"


    fi
  else
    echo "${red}${white}Invalid Function, Choose between b, d, s, p, help${reset}"
    a.sh
  fi
fi
