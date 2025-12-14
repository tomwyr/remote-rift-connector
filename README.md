# Remote Rift Connector

Local service for **Remote Rift**, an application that lets you queue for League of Legends games from your phone.

## Overview

Remote Rift Connector is a local background service that exposes an API and a CLI, enabling mobile and desktop apps to interact with the League of Legends client (LCU). It acts as a lightweight adapter that manages LCU connections, translates high-level client actions into LCU API calls and exposes game status to remote clients.

## Architecture

The project is built in Dart, allowing it to target both Windows and macOS from a single codebase while enabling code reuse and frictionless integration with the desktop application.

### Code structure

The project consists of the following packages:

- **core** - Provides integration with the LCU API (see [lcu directory](./packages/core/lib/src/lcu)) and exposes a service to interact with the game client (see [RemoteRiftConnector](./packages/core/lib/src/connector.dart)).

- **api** - Wraps the **core** package, exposing it as a REST API (see [api directory](./packages/api/src/api)) and providing a minimal CLI to start the service (see [cli directory](./packages/api/src/cli)).

When launched, the service starts an HTTP server that maps its endpoints to the **core** package's connector class. This allows clients to send commands and request data via HTTP, as well as receive continuous updates via WebSockets.

### Authentication

The LCU API requires authenticating using credentials obtained from a lockfile stored in the game directory while the client is running. If the service is launched while the League client is not active or if the lockfile is missing, the connector API will be unable to communicate with the game and will return a relevant error response.

## Usage

To run the connector service and allow connections from the mobile application:

1. Download the latest executable from the [releases page](https://github.com/tomwyr/remote-rift-connector/releases) for your operating system. Builds are available for Windows and macOS.

2. Start the connector service API from the command line:

    ```sh
    RemoteRift --host <host> --port <port>
    ```

    The command will expose the service at `http://<host>:<port>` and `ws://<host>:<port>`.

> [!important]
> To be able to connect from a mobile device, make sure to set the `host` parameter to the computer’s local network address, for example:
> `RemoteRift --host 192.168.10.52 --port 8080`

3. Ensure the League client is running on the same machine.

## Development

To run the project locally:

1. Ensure Dart is installed.
2. Run `dart pub get`.
3. Run `dart run packages/api/src/main.dart --host <host> --port <port>`.

> [!note]
> Alternatively, run the _remote-rift-connector_ launch configuration from VS Code and provide the required parameters.

4. After making changes to the source code, restart the service from the command line or use hot reload when running from VS Code.

## Related Projects

- [Remote Rift Website](https://github.com/tomwyr/remote-rift-website) — A landing page showcasing the application and guiding users on getting started.
- [Remote Rift Desktop](https://github.com/tomwyr/remote-rift-desktop) — A desktop application that launches and manages the local connector service.
- [Remote Rift Mobile](https://github.com/tomwyr/remote-rift-mobile) — A mobile application that allows remote interaction with the League client.
