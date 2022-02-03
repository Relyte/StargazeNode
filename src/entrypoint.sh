#!/bin/bash

CONFIG="/root/.starsd/config"
DATA="/root/.starsd/data"

init_daemon_config() {
    if [[ ${CONFIG_INIT} == "True" || ! -f $CONFIG/config_init ]]; then
        #Set persistent chain-id for daemon
        if [[ -z ${CHAIN_ID} ]]; then
            starsd config chain-id stargaze-1
            export CHAIN_ID="stargaze-1"
        else
            starsd config chain-id ${CHAIN_ID}
        fi

        #Initialize Osmosis Working Directory
        starsd init --chain-id=${CHAIN_ID} ${NODE_MONIKER}

        #Replace Genesis File
        curl -s ${GENESIS_FILE} > genesis.tar.gz
        tar -C $CONFIG -xvf genesis.tar.gz

        sed -i "s/^persistent_peers = \"\"/persistent_peers = \"${PERSISTENT_PEERS}\"/" $CONFIG/config.toml
        sed -i "s/^minimum-gas-prices = \"0ustars\"/minimum-gas-prices = \"${MIN_GAS_PRICE}\"/" $CONFIG/app.toml
        touch $CONFIG/config_init
    fi
}

download_chain_data() {
    if [[ ${DOWNLOAD_CHAIN_DATA} == "True" || ! -f $DATA/chain_downloaded ]]; then
        if [[ ${NODE_SIZE} == "Full" ]]; then
            if [[ -z $SNAPSHOT ]]; then
                SNAPSHOT_DATE=$(curl https://snapshots.stakecraft.com/ | grep stargaze-1 | cut -d "_" -f 2 | cut -d "." -f 1)
                SNAPSHOT="https://snapshots.stakecraft.com/stargaze-1_${SNAPSHOT_DATE}.tar"
            fi
            cd $DATA
            if [[ ${ARIA2C} == "True" ]]; then
                aria2c -x5 $SNAPSHOT
                tar -xf stargaze*.tar
                rm stargaze*.tar
            else
                wget -O - $SNAPSHOT | tar -xf -
            fi
        else
            #Download Pruned snapshot when available
            #Currently there only appears to be full snapshots
            if [[ -z $SNAPSHOT ]]; then
                SNAPSHOT_DATE=$(curl https://snapshots.stakecraft.com/ | grep stargaze-1 | cut -d "_" -f 2 | cut -d "." -f 1)
                SNAPSHOT="https://snapshots.stakecraft.com/stargaze-1_${SNAPSHOT_DATE}.tar"
            fi
            cd $DATA
            if [[ ${ARIA2C} == "True" ]]; then
                aria2c -x5 $SNAPSHOT
                tar -xf stargaze*.tar
                rm stargaze*.tar
            else
                wget -O - $SNAPSHOT | tar -xf -
            fi
        fi
        touch $DATA/chain_downloaded
    fi
}

init_daemon_config
download_chain_data

cosmovisor start

exit 0