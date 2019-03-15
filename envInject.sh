#!/usr/bin/env bash

if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters"
    echo "Usage: $0 /source/dir/ /dest/dir/"
    exit 1
fi

SOURCE_DIR=$(realpath ${1})
DESTINATION_DIR=$(realpath ${2})
VAR_NAMES=$(egrep -roh "#[^ ].*[^ ]#" ${SOURCE_DIR}/* | cut -d "#" -f2 | sort | uniq)

KEYS=()
VALUES=()
INDEX=0
while read -r KEY; do
  VALUES+=("$(env | egrep "^${KEY}=" | cut -d "=" -f2- )")
  KEYS+=("${KEY}")
  INDEX=$(( INDEX + 1))
done <<< "${VAR_NAMES}"

for FILE in ${SOURCE_DIR}/*; do
  cp -R ${FILE} ${DESTINATION_DIR}/$(basename ${FILE})
done

FILES=$(find ${DESTINATION_DIR} -type f)

for FILE in ${FILES}; do
  for i in $(seq 0 $((${#KEYS[@]} - 1))); do
    sed -i -e "s@#${KEYS[i]//@/\\@}#@${VALUES[i]//@/\\@}@g" ${FILE}
  done;
done