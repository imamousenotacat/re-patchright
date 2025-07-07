echo "Patching complete. Uploading to GitHub..."
VERSION_NUMBER="${playwright_version#v}"
RELEASE_DESCRIPTION="This is a manual deployment of a patched version of [microsoft/playwright](https://github.com/microsoft/playwright).\nThe original Release can be seen [here](https://github.com/microsoft/playwright/releases/tag/v1.52.0)."

# Step 1: Create a new GitHub release and get the upload URL
RELEASE_RESPONSE=$(curl -s -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"tag_name\": \"$playwright_version\", \"name\": \"$playwright_version\", \"body\": \"$RELEASE_DESCRIPTION\", \"draft\": false, \"prerelease\": false}" \
  "https://api.github.com/repos/$REPO/releases")

echo "$RELEASE_RESPONSE"

# Remove line breaks from the response
RELEASE_RESPONSE=$(echo "$RELEASE_RESPONSE" | tr -d '\n')
# Extract the upload URL from the release response
UPLOAD_URL=$(echo $RELEASE_RESPONSE | sed 's/$/\\n/' | tr -d '\n' | sed -e 's/“/"/g' -e 's/”/"/g' | sed '$ s/\\n$//' | jq -r .upload_url | sed "s/{?name,label}//")

# Check if upload URL was extracted correctly
if [ -z "$UPLOAD_URL" ]; then
    echo "Failed to create release. Exiting."
    exit 1
fi

# Step 2: Upload each .zip file in the directory as an asset
for ZIP_FILE in "/playwright-$VERSION_NUMBER-mac.zip" "/playwright-$VERSION_NUMBER-mac-arm64.zip" "/playwright-$VERSION_NUMBER-linux.zip" "/playwright-$VERSION_NUMBER-linux-arm64.zip" "/playwright-$VERSION_NUMBER-win32_x64.zip" "/playwright-$VERSION_NUMBER-win32_arm64.zip";
    do
      FILE_NAME=$(basename "$ZIP_FILE")
      echo "Uploading $FILE_NAME..."
      echo "token $GITHUB_TOKEN"

      curl -s -X POST \
      -H "Authorization: token $GITHUB_TOKEN" \
      -H "Content-Type: application/zip" \
      --data-binary @"./playwright/utils/build/output/$ZIP_FILE" \
      "$UPLOAD_URL?name=$FILE_NAME"
    done

echo "\n\nRelease and assets uploaded successfully!"