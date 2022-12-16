#!/bin/bash


args=("$@")
self_update() {
# This function will update HeavyScript if a new version is available
git fetch --tags &>/dev/null
git reset --hard &>/dev/null

# Get the latest version from git
latest_ver=$(git describe --tags "$(git rev-list --tags --max-count=1)")
echo "🅂 🄴 🄻 🄵"
echo "🅄 🄿 🄳 🄰 🅃 🄴"

# Get the current version of HeavyScript
if  [[ "$hs_version" != "$latest_ver" ]] ; then
    echo "Found a new version of HeavyScript, updating myself..."
    git checkout "$latest_ver" &>/dev/null 
    count=0

    # Remove the --self-update argument from the array
    for i in "${args[@]}"
    do
        [[ "$i" == "--self-update" ]] && unset "args[$count]" && break
        ((count++))
    done
    echo "Updating from: $hs_version"
    echo "Updating To: $latest_ver"
    echo "Changelog:"

    # Get the changelog from the latest release
    curl --silent "https://api.github.com/repos/HeavyBullets8/heavy_script/releases/latest" | jq -r .body
    echo 
    [[ -z ${args[*]} ]] && echo -e "No more arguments, exiting..\n\n" && exit
    echo -e "Running the new version...\n\n"
    sleep 5
    
    # Run the new version of HeavyScript
    exec bash "$script_name" "${args[@]}"

    # Now exit this old instance
    exit
else 
    echo "HeavyScript is already the latest version:"
    echo -e "$hs_version\n\n"
fi
}
export -f self_update