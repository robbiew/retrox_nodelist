#!/bin/bash
# v2

ORIGDIR=$PWD
IWORKDIR="/home/bbs/git/retrox_nodelist"
IPACKDIR="/home/bbs/git/retrox_infopack"
WORKDIR="${1:-$IWORKDIR}"
PACKDIR="${2:-$IPACKDIR}"

COMMIT="Post compile auto-commit: $(date "+%Y-%m-%d %H:%M:%S")"

ISOK=false

#echo -n "Did you save and commit changes in both $IWORKDIR and $IPACKDIR?: "; read ANSWER
#case "$ANSWER" in
#  "no")  echo "Aborted, go save and commit!"; exit 1;;
#  *) echo "continue";;
#esac

# echo "*** DID YOU SAVE AND COMMIT YOUR CHANGES TO BOTH $WORKDIR AND $PACKDIR? ***"
# for i in {5..1}; do
#   echo -n "$i... "
#   sleep 1
# done
# echo "0. Times up!"

cd $WORKDIR
# git pull

echo "Compiling nodelist..."
makenl -d nodelist.txt >/dev/null

absfile=$(ls -rt outfile/retrox.[0-9]*|tail -1)
file=$(echo $(basename $absfile))
ext=$(echo $file | awk -F. '{ print $2 }') 
newext="z${ext:1:2}" 

echo "Creating zip archive retrox.$newext..."
[ -f zip/retrox.$newext ] && mv zip/retrox.$newext{,.`date +%Y%m%d`}
zip -j9 zip/retrox.$newext $absfile

# git add . -A
# git commit -m "$COMMIT"
# git push

cd $PACKDIR
echo "Now in $PACKDIR directory..."

# git pull

rm $PACKDIR/retrox.z*
rm $PACKDIR/retroxinfo.zip

echo "Copy $WORKDIR/zip/retrox.$newext $PACKDIR/"
cp $WORKDIR/zip/retrox.$newext $PACKDIR/

echo "Creating zip archive $PACKDIR/retroxinfo.zip..."
zip -j9 $PACKDIR/retroxinfo.zip $PACKDIR/*

# git add . -A
# git commit -m "$COMMIT"
# git push

cd $ORIGDIR

