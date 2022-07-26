#!/usr/bin/env bash

if ! command -v "jq" &> /dev/null; then
    echo "You are missing a dependency. Install 'jq' and try again!"
    exit
elif ! command -v "tr" &> /dev/null; then
    echo "You are missing a dependency. Install 'tr' and try again!"
    exit
fi

bold="$(tput bold)"
normal="$(tput sgr0)"
version=""

if [ "${0}" == "./user.sh" ]; then
    version="$(cat ../version)"
elif [ "${0}" == "./scripts/user.sh" ]; then
    version="$(cat ./version)"
fi

echo -e "\n|---------------- ${bold}RBXKeyscore v${version}${normal} ----------------|\n\n"

echo -n "Search user: ${bold}"
read name
echo -e "${normal}\nFetching..."

uid="$(curl -s https://api.roblox.com/users/get-by-username?username=${name} | jq '.Id')"
profile="$(curl -s https://users.roblox.com/v1/users/${uid})"
username_history="$(curl -s https://users.roblox.com/v1/users/${uid}/username-history)"
friends="$(curl -s https://friends.roblox.com/v1/users/${uid}/friends/count)"
followings="$(curl -s https://friends.roblox.com/v1/users/${uid}/followings/count)"
followers="$(curl -s https://friends.roblox.com/v1/users/${uid}/followers/count)"
presence="$(curl -s -X POST --header 'Content-Type: application/json' -d {'userIds':[${uid}]} https://presence.roblox.com/v1/presence/users)"
acc_info="$(curl -s https://accountinformation.roblox.com/v1/users/${uid}/roblox-badges)"

if [ "$(echo ${profile} | jq '.name' | tr --delete '\"')" == "null" ]; then
    echo -e "Failed!\n\nNo users with this name were found. Check your spelling and try again!\n"
    exit
fi

echo "Done!"

cat << EOF

${bold}ID:${normal} ${uid}
${bold}Username:${normal} $(echo ${profile} | jq ".name" | tr --delete '\"')
${bold}Display Name:${normal} $(echo ${profile} | jq ".displayName" | tr --delete '\"')
${bold}Description:${normal} $(echo ${profile} | jq ".description" | tr --delete '\"')
${bold}Last location:${normal} $(echo ${presence} | jq ".userPresences[] | .lastLocation" | tr --delete '\"')
${bold}Friends:${normal} $(echo ${friends} | jq ".count")
${bold}Following:${normal} $(echo ${followings} | jq ".count")
${bold}Followers:${normal} $(echo ${followers} | jq ".count")
${bold}Past usernames:${normal} $(echo ${username_history} | jq ".data[] | .[]" | cut -c 2-  | tr '\"\n' '; ')
${bold}Roblox badges:${normal} $(echo ${acc_info} | jq ".[] | .name" | cut -c 2- | tr '\"\n' '; ')
${bold}Creation date:${normal} $(echo ${profile} | jq ".created" | tr --delete '\"')
${bold}Banned:${normal} $(echo ${profile} | jq ".isBanned")
${bold}Profile:${normal} https://roblox.com/users/${uid}/profile

${bold}Search date:${normal} $(date +%m/%d/%Y) at $(date +%T) [UTC: $(date +%s)]

EOF