#!/bin/bash
create_new_release(){
    
    tag_number=$(grep -oP '^releaseNo=\K[^\s]+' " ./releaseNo.env" )
    tag_with_prefix="v ${tag_number}-development"
    gh api \
    --method POST \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    /repos/rana7862/GitHub-prac/releases \
    -F tag_name="$tag_with_prefix" \
    -F target_commitish="development" \
    -F name="$tag_with_prefix" \
    -F draft=false \
    -F prerelease=false \
    -F body=@"./modify.txt"
    echo "Release $tag_with_prefix created successfully."
    

}
main(){
    create_new_release
}
main 