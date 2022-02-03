# StargazeNode Docker
StargazeNode is a Docker container available at [Docker Hub](INSERT_DOCKERHUB_LINK). It's designed to allow for a more efficient way of getting a Stargaze Full or Pruned Node configured and ready to sync to the network.

## Installation
The Docker image can be pulled from the Docker Hub repository and run with `docker-compose`.


### Docker-Compose
Pull down this source code and enter the new directory by running the following commands:

```
git clone https://github.com/Relyte/StargazeNode.git
cd StargazeNode
```

Edit the `container.env` file to set the environement variables as desired. A full list of variables and their supported values is provided below.

Edit the `example.env` file and set the proper volume mount locations based on system preference. Save the modified file as `.env`.

Run the following command to start the container:
`docker-compose up -d`

To view the logs as it downloads and syncs, run the following command:
`docker-compose logs -f`

To stop the container, run:
`docker-compose down`

## Environment Variables
| Variable    | Description | Values |
| ----------- | ----------- | -------|
| ARIA2C | Indicates whether to use aria2 or wget as the download manager for the blockchain data       | `True` (default), `False`       |
| CHAIN_ID | Indicates the chain-id that should be synced to        | `stargaze-1`        |
| DOWNLOAD_CHAIN_DATA | Indicates if the blockchain snapshot should be downloaded       |`True`, `False` (default)        |
| GENESIS_FILE | Link to the genesis file to be used      | `https://raw.githubusercontent.com/public-awesome/mainnet/main/stargaze-1/genesis.tar.gz`        |
| MIN_GAS_PRICE | The minimum gas price (only affects validator nodes) | `0.001ustars`        |
| NODE_MONIKER | Name of the node (only affects validator nodes) | `DockerStargazeNode`        |
| NODE_SIZE | Indicates whether a full or pruned snapshot should be used | `Full` (default), `Pruned`|
| PERSISTENT_PEERS      | A list of peers to connect to initially when syncing to the current blockchain height |        |

## Building from source
In addition to the Docker Hub image, it is possible to build the image from source using the provided Dockerfile. To build the image from source, run the following command:

```
git clone https://github.com/Relyte/StargazeNode.git
cd StargazeNode
docker build .
```

In order to use the locally built image, the docker-compose.yml file will need to be modified.

`cd ..` and edit the docker-compose.yml file to use the name of the local image in place of `relyte/stargaze-docker:0.1.3`