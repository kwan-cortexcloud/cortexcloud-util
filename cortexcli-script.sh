# set envvars for cortex cloud
export CORTEX_API_BASE_URL=<REDACT>
export CORTEX_API_KEY_ID=<REDACT>
export CORTEX_API_KEY=<REDACT>

# get token for pulling cortexcli image
TOKEN_RESPONSE=$(curl --location "$CORTEX_API_BASE_URL/public_api/v1/unified-cli/image/token" \
            --header "Authorization: $CORTEX_API_KEY" \
            --header "x-xdr-auth-id: $CORTEX_API_KEY_ID" \
            --header 'Content-Type: application/json' \
            --data '{}')
TOKEN=$(echo $TOKEN_RESPONSE | jq -r '.token')

docker build --build-arg TOKEN=$TOKEN . -t cortexcliwithca:amd64-0.13.0 

##Sample command to use it for code scan
# docker run --rm -v .:/home/code cortexcliwithca:amd64-0.13.0 \
#         --api-base-url $CORTEX_API_BASE_URL \
#         --api-key $CORTEX_API_KEY \
#         --api-key-id $CORTEX_API_KEY_ID \
#         code scan \
#         --directory /home/code \
#         --repo-id my/myapp\
#         --branch main \
#         --source CORTEX_CLI \
#         --create-repo-if-missing