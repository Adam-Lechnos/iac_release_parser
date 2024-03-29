#!/bin/bash

source 'auth.cfg with token(s)'

/usr/local/bin/gh config set git_protocol ssh --host github.com
/usr/local/bin/gh auth login -h github.com --with-token < <(echo "${githubTokenGUI}")

authToken=$githubTokenGUI
repoName=$1
repoRelease=$2
isGUI=$3
repoNameTrim=`echo $repoName | cut -d':' -f2 | cut -d'/' -f2 | sed 's/.git//g'`
repoOwner=`echo $repoName | cut -d':' -f2 | cut -d'/' -f1`
devopsRepo="git@github.com:repo/devops_test.git"
devopsReleases=`/usr/local/bin/gh release list -L 50 -R $devopsRepo | awk '{print $1}' | sed 's/^v//; s/^V//' | grep -Eo "[0-9]+.[0-9]+.[0-9]+(-\w+)?(\.\w+)?" | tr "\n" " "`
devopsReleasesDD=`/usr/local/bin/gh release list -L 50 -R $devopsRepo | awk '{print $1}' | grep -Eo "(v|V)?[0-9]+.[0-9]+.[0-9]+(-\w+)?(\.\w+)?" | tr "\n" " "`
logDir='log directory here'

# parse iac.json from image repo
parse_iac () {

  payload='query {
  repository(owner: \"'$repoOwner'\", name: \"'$repoNameTrim'\") {
    content:object(expression: \"'$repoRelease':iac.json\") {
      ... on Blob {
        text
      }
    }
    }
  }'

  payloadFrmt="$(echo $payload)"

  logretention=20
  loglist=$(ls -l /'add directory here'/iac_release_parser/logs/ | grep .log | awk '{print $9}' | wc -l)

  if [ ! -d $logDir/iac_release_parser/logs ]; then
    mkdir $logDir/iac_release_parser/logs
  fi

  if [ $loglist -gt $logretention ]
  then

  delcount=`expr $loglist - $logretention`
  find $logDir/iac_release_parser/logs/ -type f -printf '%T+ %p\n' | sort | head -n $delcount | awk '{print $2}' | sed 's/[^\]*logs[^\]//' | xargs -I {} rm $logDir/iac_release_parser/logs/{}

  fi

  display_ver=`curl \
  -s -H "Authorization: bearer $authToken" \
  -X POST -d "{ \"query\": \"$payloadFrmt\"}" https://api.github.com/graphql \
  | jq -r '.data.repository.content.text' | jq -r '.devops_release'`

  echo $display_ver

  exitStatus=$?

  if [ $exitStatus -ne 0 ]
  then

  timestamp=$(date +"%FT%H%M%S")

  curl -s -I \
  -H "Authorization: bearer $authToken" \
  https://api.github.com/graphql > $logDir/iac_release_parser/logs/cURLheader_$timestamp.log

  fi

}


check_iac=$(parse_iac)

if [ "$check_iac" == "null" ]
then
  if [ "$isGUI" == "yes" ]
  then
    echo "$devopsReleasesDD"
  else
    echo $devopsReleasesDD |tr " " "\n" | head --lines=1
  fi
  #echo $devopsReleases | tr " " "\n" | head --lines=1
else
  #echo $check_iac
  echo "v`npx sh-semver -r $check_iac $devopsReleases | tail --lines=1`"
fi
