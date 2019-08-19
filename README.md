# node-in-a-box-shell

> `ash` shell initialization for Node.js development
  in an Alpine Linux Docker container, fit for using the
  [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
  extension for
  [Visual Studio Code Insiders](https://code.visualstudio.com/insiders/).

## Usage

### `docker-compose.yml`

Example for a consuming project that lives in
a sibling directory in the file system:

    services:
      app:
        environment:
          - ENV=/home/node/shell/ash.sh
          - PROJECT=your-project-name-as-seen-in-ps1
        volumes:
          - ../node-in-a-box-shell/source:/home/node/shell
