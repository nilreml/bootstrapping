#!/usr/bin/env bash

USERNAME=$(whoami)

SUDOERS_PATH="/etc/sudoers.d"
SUDOERS_FILE="${USERNAME}"
SUDOERS_STRING="${USERNAME} ALL=(ALL:ALL) NOPASSWD:ALL"

APT_SOURCES_NAME="buster-backports"
APT_SOURCES_MIRROR="http://mirror.netcologne.de/debian/"
APT_SOURCES_PATH="/etc/apt/sources.list.d"
APT_SOURCES_FILE="${APT_SOURCES_NAME}.list"
APT_SOURCES_STRING="${APT_SOURCES_MIRROR} ${APT_SOURCES_NAME} main contrib non-free"
APT_SOURCES_STRING_1="deb ${APT_SOURCES_STRING}"
APT_SOURCES_STRING_2="deb-src ${APT_SOURCES_STRING}"

su -c "echo '${SUDOERS_STRING}'>'${SUDOERS_PATH}/${SUDOERS_FILE}'"

COMMANDS=(
  "usermod -aG sudo ${USERNAME}"
  echo ${APT_SOURCES_STRING_1}>${APT_SOURCES_PATH}/${APT_SOURCES_FILE}
  echo ${APT_SOURCES_STRING_2}>${APT_SOURCES_PATH}/${APT_SOURCES_FILE}
  apt autoclean
  apt update
  apt dist-upgrade -y
  apt autoremove --purge -y
  apt install vim git
)

for COMMAND in "${COMMANDS[@]}"; do
  sudo ${COMMAND}
done
