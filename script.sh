#!/bin/bash
# create_new_release(){
    
#     tag_number=$(grep -oP '^releaseNo=\K[^\s]+' "./releaseNo.env" )
#     tag_with_prefix="v${tag_number}-development"
#     gh api \
#     --method POST \
#     -H "Accept: application/vnd.github+json" \
#     -H "X-GitHub-Api-Version: 2022-11-28" \
#     /repos/rana7862/GitHub-prac/releases \
#     -F tag_name="$tag_with_prefix" \
#     -F target_commitish="development" \
#     -F name="$tag_with_prefix" \
#     -F draft=false \
#     -F prerelease=false \
#     -F body=@"./modify.txt"
#     echo "Release $tag_with_prefix created successfully."
    

# }
# main(){
#     create_new_release
# }
# main 

APP_NAME="MyApp"
VERSION=$(grep -oP '^releaseNo=\K[^\s]+' "./releaseNo.env")
OUTPUT_DIR="releases/windows"
EXE_FILE="${APP_NAME}-${VERSION}.exe"
TAG_NAME="v${VERSION}-development"
REPO="rana7862/GitHub-prac"

create_new_release() {
    echo "Creating GitHub release: $TAG_NAME ..."
    gh api \
        --method POST \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        /repos/$REPO/releases \
        -F tag_name="$TAG_NAME" \
        -F target_commitish="development" \
        -F name="$TAG_NAME" \
        -F draft=false \
        -F prerelease=false \
        -F body=@"./modify.txt"
    echo "✅ Release $TAG_NAME created successfully."
}

build_windows_package() {
    echo " Building Windows installer..."
    # Build with NSIS (needs installer.nsi in repo)
    makensis -DVERSION="$VERSION" installer.nsi

    echo "Moving installer into repo folder..."
    mkdir -p "$OUTPUT_DIR"
    mv "$EXE_FILE" "$OUTPUT_DIR/"

    echo "Windows package $EXE_FILE built and stored in $OUTPUT_DIR/"
}

upload_windows_package() {
    echo "📎 Uploading $EXE_FILE to release $TAG_NAME ..."
    gh release upload "$TAG_NAME" "$OUTPUT_DIR/$EXE_FILE" --repo "$REPO" --clobber
    echo "Windows package uploaded successfully."
}

main() {
    build_windows_package
    create_new_release
    upload_windows_package
}

main
