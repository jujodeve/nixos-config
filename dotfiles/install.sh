#!/usr/bin/env bash

SCRIPT_PATH=$(dirname $(realpath -s $0))

THIS_SCRIPT=$(realpath -s $0)

DOTFILES_PATH=$SCRIPT_PATH

TARGET_PATH=$HOME

process-file() {

    FILE=$1
    DIR=$2
    FILE_RELATIVE=$(echo $FILE | sed "s,$2,,g")
    DESTINY=$TARGET_PATH$FILE_RELATIVE

    CMD=""

    [[ -d $FILE ]] && [[ ! -d $DESTINY ]] && mkdir -p $DESTINY

    [[ -f $DESTINY ]] && mv $DESTINY $DESTINY.backup

    [[ -f $FILE ]] && [[ "$FILE" != "$THIS_SCRIPT" ]] && echo procesing $FILE && ln -sf $FILE $DESTINY

}

process-dir() {
    DIR=$1
    find $DIR | while read -r file; do  process-file $file $DIR; done
}

echo
echo Linking dotfiles.
process-dir $DOTFILES_PATH

