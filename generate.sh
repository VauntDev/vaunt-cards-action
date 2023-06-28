#!/bin/bash

mkdir -p .vaunt/cards

conributorsFile=.vaunt/cards/contributors.svg

if [ -z ${TOKEN} ]
then
    # Token not set
    echo "https://api.vaunt.dev/v1/github/entities/${ENTITY}/repositories/${REPOSITORY}/contributors?format=svg&limit=${LIMIT}"
    response=$(curl --compressed -H "content-type: application/json" --write-out '%{http_code}' --output $conributorsFile "https://api.vaunt.dev/v1/github/entities/${ENTITY}/repositories/${REPOSITORY}/contributors?format=svg&limit=${LIMIT}")
else
    # Token set, authenticate with github to get a Vaunt token first
    vauntToken=$(curl -H "content-type: application/json" -H "Authorization: Bearer ${TOKEN}" https://api.vaunt.dev/v1/github/entities/${ENTITY}/token | jq -r '.data.token')

    if [ -z ${vauntToken} ]
    then
        echo "failed to get vaunt token, see [https://docs.vaunt.dev/guides/github/creating-a-pat] for details on using token authentication"
        exit 1
    fi

    response=$(curl --compressed -H "content-type: application/json" -H "Authorization: Bearer $vauntToken" --write-out '%{http_code}' --output $conributorsFile "https://api.vaunt.dev/v1/github/entities/${ENTITY}/repositories/${REPOSITORY}/contributors?format=svg&limit=${LIMIT}")
fi

if [ $response != 200 ]
then
    echo "bad response from API: $response"
    exit 1
fi
