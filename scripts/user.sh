#!/usr/bin/env bash

if ! command -v "jq" &> /dev/null
then
    echo "You are missing a dependency. Install 'jq' and try again!"
    exit
elif ! command -v "tr" &> /dev/null
then
    echo "You are missing a dependency. Install 'tr' and try again!"
    exit
fi

version="$(cat ./version)"

echo -e "\n|--------------- RBXKeyscore v${version} ---------------|\n\n"

echo -n "Search user: "
read name
echo -e "\nFetching..."

uid="$(curl -s https://api.roblox.com/users/get-by-username?username=${name} | jq '.Id')"

data="$(curl -s https://users.roblox.com/v1/users/${uid})"

if [ "$(echo ${data} | jq '.name' | tr --delete '\"')" == "null" ]
then
    echo -e "Failed!\n\nNo users with this name were found. Check your spelling and try again!\n"
    exit
fi

echo "Done!"

cat << EOF

--- $(date +%m/%d/%Y) at $(date +%T) [UTC: $(date +%s)] ---

Username: $(echo ${data} | jq ".name" | tr --delete '\"')
Display Name: $(echo ${data} | jq ".displayName" | tr --delete '\"')
Description: $(echo ${data} | jq '.description' | tr --delete '\"')
Creation date: $(echo ${data} | jq ".created" | tr --delete '\"')
Past usernames: $(curl -s https://users.roblox.com/v1/users/${uid}/username-history | jq '.data[] | .[]' | tr --delete '\"'  | tr '\n' ' ')
Profile: https://roblox.com/users/${uid}/profile

EOF
