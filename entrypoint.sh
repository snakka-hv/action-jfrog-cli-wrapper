#!/bin/sh

set -e

echo "Authenticating using $INPUT_CREDENTIALS_TYPE";

# Authenticate to the server
if [ $INPUT_CREDENTIALS_TYPE == "username" ];
then
  sh -c "jfrog rt c action-server --interactive=false --url=$INPUT_URL --user=$INPUT_USER --password=$INPUT_PASSWORD"
elif [ $INPUT_CREDENTIALS_TYPE == "apikey" ];
then
  sh -c "jfrog rt c action-server --interactive=false --url=$INPUT_URL --apikey=$INPUT_APIKEY"
elif [ $INPUT_CREDENTIALS_TYPE == "accesstoken" ];
then
  sh -c "jfrog rt c action-server --interactive=false --url=$INPUT_URL --access-token=$INPUT_ACCESS_TOKEN"
fi
sh -c "jfrog rt use action-server"

# Set working directory if specified
if [ $INPUT_WORKING_DIRECTORY != '.' ];
then
  cd $INPUT_WORKING_DIRECTORY
fi


rest=$INPUT_ARTIFACTFROM
while [ -n "$rest" ] ; do
  str=${rest%%;*}  # Everything up to the first ';'
  # Trim up to the first ';' -- and handle final case, too.
  [ "$rest" = "${rest/;/}" ] && rest= || rest=${rest#*;}
  echo "+ \"$str\""
  echo "[Info] Uploading artifact: jfrog rt u $str $INPUT_ARTIFACTTO --build-name=$INPUT_BUILDNAME --build-number=$INPUT_BUILDNUMBER"
  outputUpload=$( sh -c "jfrog rt u $str $INPUT_ARTIFACTTO --build-name=$INPUT_BUILDNAME --build-number=$INPUT_BUILDNUMBER" )
  echo "$outputUpload" > "${HOME}/${GITHUB_ACTION}.log"
  echo "$outputUpload"
done

## Log command for info
#echo "[Info] Uploading artifact: jfrog rt u $INPUT_ARTIFACTFROM $INPUT_ARTIFACTTO --build-name=$INPUT_BUILDNAME --build-number=$INPUT_BUILDNUMBER"
## Capture output
#outputUpload=$( sh -c "jfrog rt u $INPUT_ARTIFACTFROM $INPUT_ARTIFACTTO --build-name=$INPUT_BUILDNAME --build-number=$INPUT_BUILDNUMBER" )
## Write for further analysis if needed
#echo "$outputUpload" > "${HOME}/${GITHUB_ACTION}.log"
## Write output to STDOUT
#echo "$outputUpload"

# Conditional build publish
if [ $INPUT_PUBLISH == "true" ];
then
  echo "[Info] Pushing build info: jfrog rt bce $INPUT_BUILDNAME $INPUT_BUILDNUMBER"
  outputPushInfo=$( sh -c "jfrog rt bce $INPUT_BUILDNAME $INPUT_BUILDNUMBER")

  echo "[Info] Pushing build artifacts: jfrog rt bp $INPUT_BUILDNAME $INPUT_BUILDNUMBER"
  outputPublish=$( sh -c "jfrog rt bp $INPUT_BUILDNAME $INPUT_BUILDNUMBER")

  echo "$outputPushInfo" > "${HOME}/${GITHUB_ACTION}.log"
  echo "$outputPublish" > "${HOME}/${GITHUB_ACTION}.log"
  echo "$outputPushInfo"
  echo "$outputPublish"
fi
