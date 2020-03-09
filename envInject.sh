#!/usr/bin/env bash

if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters"
    echo "Usage: $0 /source/dir/ /dest/dir/"
    exit 1
fi

SOURCE_DIR=$(realpath ${1})
DESTINATION_DIR=$(realpath ${2})
VAR_NAMES=$(egrep -roh "#[^ \n]*#(.*#)?" ${SOURCE_DIR}/* | sort -r | uniq)

KEYS=()
VALUES=()
INDEX=0
while read -r KEY; do
  ENV_KEY=$(echo "$KEY" | cut -d "#" -f2 )
  VALUE=("$(env | egrep "^${ENV_KEY}=" | cut -d "=" -f2- )")
  if [ -z "${VALUE}" ]; then
    VALUE=$(echo "$KEY" | cut -d "#" -f3- | rev | cut -d"#" -f2- | rev)
  fi
  VALUES+=("${VALUE}")
  KEYS+=("${KEY}")
  INDEX=$(( INDEX + 1))
done <<< "${VAR_NAMES}"

for FILE in ${SOURCE_DIR}/*; do
  cp -R ${FILE} ${DESTINATION_DIR}/$(basename ${FILE})
done

FILES=$(find ${DESTINATION_DIR} -type f)

for FILE in ${FILES}; do
  for i in $(seq 0 $((${#KEYS[@]} - 1))); do
    sed -i -e "s@${KEYS[i]//@/\\@}@${VALUES[i]//@/\\@}@g" ${FILE}
  done;
done
