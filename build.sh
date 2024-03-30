#!/bin/bash

# check if .env exists
if [ ! -f .env ]; then
    echo ".env file not found, please create one!";
    echo "creating .env file...";
    cp env.example .env;

    # ask user for SOURCE_RPC_URL and replace it in .env
    if [ -z "https://rpc.ankr.com/eth" ]; then
        echo "Enter SOURCE_RPC_URL: ";
        read SOURCE_RPC_URL;
        sed -i'.backup' "s#<source-rpc-url>#https://rpc.ankr.com/eth#" .env
    fi

    # ask user for SIGNER_ACCOUNT_ADDRESS and replace it in .env
    if [ -z "0xe41528076bE7Ea1e6c7F6B2321831BF681200E62" ]; then
        echo "Enter SIGNER_ACCOUNT_ADDRESS: ";
        read SIGNER_ACCOUNT_ADDRESS;
        sed -i'.backup' "s#<signer-account-address>#0xe41528076bE7Ea1e6c7F6B2321831BF681200E62#" .env
    fi

    # ask user for SIGNER_ACCOUNT_PRIVATE_KEY and replace it in .env
    if [ -z "5d70a9c5caa6cb2332be7bcf6d3e353532dd5fd446ba3850784981c810c1b4c7" ]; then
        echo "Enter SIGNER_ACCOUNT_PRIVATE_KEY: ";
        read SIGNER_ACCOUNT_PRIVATE_KEY;
        sed -i'.backup' "s#<signer-account-private-key>#5d70a9c5caa6cb2332be7bcf6d3e353532dd5fd446ba3850784981c810c1b4c7#" .env
    fi

    # ask user for SLOT_ID and replace it in .env
    if [ -z "1099" ]; then
        echo "Enter Your SLOT_ID (NFT_ID): ";
        read SLOT_ID;
        sed -i'.backup' "s#<slot-id>#1099#" .env
    fi

fi

source .env

if [ -z "$OVERRIDE_DEFAULTS" ]; then
    echo "reset to default values...";
    export PROST_RPC_URL="https://rpc-prost-1h.powerloom.io"
    export PROTOCOL_STATE_CONTRACT="0xa71Bb0F24744E86a4ABe3C97bA8dd762A5313ADD"
    export PROST_CHAIN_ID="11165"
fi

echo "testing before build...";

if [ -z "$SOURCE_RPC_URL" ]; then
    echo "RPC URL not found, please set this in your .env!";
    exit 1;
fi

if [ -z "$SIGNER_ACCOUNT_ADDRESS" ]; then
    echo "SIGNER_ACCOUNT_ADDRESS not found, please set this in your .env!";
    exit 1;
fi

if [ -z "$SIGNER_ACCOUNT_PRIVATE_KEY" ]; then
    echo "SIGNER_ACCOUNT_ADDRESS not found, please set this in your .env!";
    exit 1;
fi

echo "Found SOURCE RPC URL ${SOURCE_RPC_URL}";

echo "Found SIGNER ACCOUNT ADDRESS ${SIGNER_ACCOUNT_ADDRESS}";

if [ "$PROST_RPC_URL" ]; then
    echo "Found PROST_RPC_URL ${PROST_RPC_URL}";
fi

if [ "$PROST_CHAIN_ID" ]; then
    echo "Found PROST_CHAIN_ID ${PROST_CHAIN_ID}";
fi

if [ "$IPFS_URL" ]; then
    echo "Found IPFS_URL ${IPFS_URL}";
fi

if [ "$PROTOCOL_STATE_CONTRACT" ]; then
    echo "Found PROTOCOL_STATE_CONTRACT ${PROTOCOL_STATE_CONTRACT}";
fi

if [ "$RELAYER_HOST" ]; then
    echo "Found RELAYER_HOST ${RELAYER_HOST}";
fi

if [ "$WEB3_STORAGE_TOKEN" ]; then
    echo "Found WEB3_STORAGE_TOKEN ${WEB3_STORAGE_TOKEN}";
fi

if [ "$SLACK_REPORTING_URL" ]; then
    echo "Found SLACK_REPORTING_URL ${SLACK_REPORTING_URL}";
fi

if [ "$POWERLOOM_REPORTING_URL" ]; then
    echo "Found SLACK_REPORTING_URL ${POWERLOOM_REPORTING_URL}";
fi

echo "building...";

if ! [ -x "$(command -v docker-compose)" ]; then
    echo 'docker compose not found, trying to see if compose exists within docker';
    docker compose pull;
    if [ "$IPFS_URL" ]; then
        docker compose --profile ipfs up -V --abort-on-container-exit
    else
        docker compose up --no-deps -V --abort-on-container-exit
    fi
else
    docker-compose pull;
    if [ "$IPFS_URL" ]; then
        docker-compose --profile ipfs up -V --abort-on-container-exit
    else
        docker-compose up --no-deps -V --abort-on-container-exit
    fi
fi
