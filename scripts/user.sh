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

version="$(cat ../version)"

echo -e "\n|--------------- RBXKeyscore v${version} ---------------|\n\n"

echo -n "Search user: "
read name
echo -e "\nFetching..."

uid="$(curl -s https://api.roblox.com/users/get-by-username?username=${name} | jq '.Id')"

profile="$(curl -s https://users.roblox.com/v1/users/${uid})"
username_history="$(curl -s https://users.roblox.com/v1/users/${uid}/username-history)"
friends="$(curl -s https://friends.roblox.com/v1/users/${uid}/friends/count)"
followings="$(curl -s https://friends.roblox.com/v1/users/${uid}/followings/count)"
followers="$(curl -s https://friends.roblox.com/v1/users/${uid}/followers/count)"

if [ "$(echo ${profile} | jq '.name' | tr --delete '\"')" == "null" ]
then
    echo -e "Failed!\n\nNo users with this name were found. Check your spelling and try again!\n"
    exit
fi

echo "Done!"

cat << EOF

--- $(date +%m/%d/%Y) at $(date +%T) [UTC: $(date +%s)] ---

ID: ${uid}
Username: $(echo ${profile} | jq ".name" | tr --delete '\"')
Display Name: $(echo ${profile} | jq ".displayName" | tr --delete '\"')
Description: $(echo ${profile} | jq '.description' | tr --delete '\"')
Past usernames: $(echo ${username_history} | jq '.data[] | .[]' | tr --delete '\"'  | tr '\n' ' ')
Friends: $(echo ${friends} | jq '.count')
Following: $(echo ${followings} | jq '.count')
Followers: $(echo ${followers} | jq '.count')
Creation date: $(echo ${profile} | jq ".created" | tr --delete '\"')
Profile: https://roblox.com/users/${uid}/profile

EOF
