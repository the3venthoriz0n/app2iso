#!/usr/bin/env bash

MONTEREY="macOS Monterey"
BIGSUR="macOS Big Sur"
CATALINA="macOS Catalina"
CHOICE=''
TMP_DIR="/tmp/app2iso"

function buildIso (){

  printf "\nConverting Install macOS $*.app to .iso...\n"

  rm $TMP_DIR.dmg

  hdiutil detach "/Volumes/app2iso"

  hdiutil create -o $TMP_DIR -size 16000m -volname app2iso -layout SPUD -fs HFS+J

  hdiutil attach $TMP_DIR.dmg -noverify -mountpoint /Volumes/app2iso

  sudo "Install macOS $*.app/Contents/Resources/createinstallmedia" --volume /Volumes/app2iso --nointeraction

  hdiutil detach "/volumes/Install macOS $*"

  hdiutil convert $TMP_DIR.dmg -format UDTO -o "$PWD/$*.cdr"

  mv "$*.cdr" "$*.iso"

  printf "\n Done! (ctrl + c to exit)"

}

select OS in "$MONTEREY" "$BIGSUR" "$CATALINA"
do
        case $OS in
                $MONTEREY)
                        CHOICE="Monterey"
                        buildIso $CHOICE
                        break
                        ;;
                $BIGSUR)
                        CHOICE="Big Sur"
                        buildIso $CHOICE
                        break
                        ;;
                $CATALINA)
                        CHOICE="Catalina"
                        buildIso $CHOICE
                        break
                        ;;
                *)
                        echo "Please choose an a version of macOS!"
                        break
                        ;;
esac
done
