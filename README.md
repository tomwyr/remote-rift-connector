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

The LCU API requires authenticating using credentials obtained from a lockfile stored in the game directory while the client is running. When connecting to the LCU API, the service attempts to read the credentials automatically from the default location based on the host operating system.

If the service is launched while the League client is not active or if the lockfile is missing, the connector API will be unable to communicate with the game and will return a relevant error response.

### Address resolution

When started with `--resolve-address`, the connector scans the host machine’s network interfaces to find a usable local IPv4 address.
Automatic address resolution binds the service to a single suitable local network address.

> [!important]
> If no address or multiple addresses are detected, startup is aborted and the host must be configured manually.

### Dependencies

This section describes selected third-party packages used throughout the application:

- [shelf](https://pub.dev/packages/shelf) - Lightweight HTTP server used to expose local APIs and handle incoming requests.

## Usage

> [!warning]
> Due to the mobile project’s `bonsoir` dependency, which requires Flutter, the connector service is incompatible with the mobile application without the desktop wrapper.
> The service can still be started and accessed without automatic address discovery.

1. Download the latest executable from the [releases page](https://github.com/tomwyr/remote-rift-connector/releases) for your operating system. Builds are available for Windows and macOS.

2. Start the connector service API from the command line in one of the available modes:

   ```sh
      # Explicit host and port
      remoterift --host <host> --port <port>

      # Automatic address lookup
      remoterift --resolve-address
   ```

   The command will expose the service at `http://<host>:<port>` and `ws://<host>:<port>`.

> [!important]
> To be able to connect from another device, make sure to set the `host` parameter to the host device's local network address, for example:
> `remoterift --host 192.168.10.52 --port 8080`

3. Ensure the League client is running on the same machine.

## Development

To run the project locally:

1. Ensure Dart is installed.
2. Run `dart pub get` to install dependencies.
3. Run the application in one of the available modes:

```sh
# Explicit host and port
dart run packages/api/lib/src/api/main.dart --host <host> --port <port>

# Automatic address lookup
dart run packages/api/lib/src/api/main.dart --resolve-address
```

> [!tip]
> Alternatively, run the _remote-rift-connector_ launch configuration from VS Code and provide the required parameters.

4. After making changes to the source code, restart the service from the command line or use hot reload when running from an IDE.

### Building project

Run `dart compile exe packages/api/lib/src/api/main.dart` to compile the project into an executable.

> [!tip]
> Alternatively, use the `connector: build` VS Code task to compile the project. The resulting binary will be placed in `packages/api/bin/remoterift`.

## Related Projects

- [Remote Rift Website](https://github.com/tomwyr/remote-rift-website) - A landing page showcasing the application and guiding users on getting started.
- [Remote Rift Desktop](https://github.com/tomwyr/remote-rift-desktop) - A desktop application that launches and manages the local connector service.
- [Remote Rift Mobile](https://github.com/tomwyr/remote-rift-mobile) - A mobile application that allows remote interaction with the League client.
- [Remote Rift Foundation](https://github.com/tomwyr/remote-rift-foundation) - A set of shared packages containing common UI, utilities, and core logic used across Remote Rift projects.
