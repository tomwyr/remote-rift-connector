## [0.12.1] - 2026-02-15

- Fixed missing pubspec asset file

## [0.12.0] - 2026-02-15

- Exposed service version in the API
- Moved service info model to foundation

## [0.11.2] - 2026-01-28

- Updated internal dependencies

## [0.11.1] - 2026-01-28

- Fixed queue name missing at times after creating lobby 
- Fixed returning `unknown` error after closing game client

## [0.11.0] - 2026-01-26

- Added querying available queues
- Added support for providing lobby queue ID

## [0.10.0] - 2026-01-26

- Added time left to `found` game state data
- Exposed queue name in game session data

## [0.9.0] - 2026-01-22

- Added support for resolving API address when multiple are available
- Exposed `HttpServer` to service runner callers
- Fixed incorrect core package dependency

## [0.8.0] - 2026-01-20

- Added resolving API config from environment and system lookup
- Added `--resolve-address` flag to CLI

## [0.7.0] - 2026-01-19

- Added versioning to internal packages

## [0.6.1] - 2026-01-10

- Moved service registry to foundation

## [0.6.0] - 2026-01-09

- Added support for automatic detection of the API adddress
- Fixed a delay in the initial game state event sent over WebSocket

## [0.5.1] - 2025-12-15

- Fixed lockfile data not refreshing after relaunching the game

## [0.5.0] - 2025-12-15

- Added core logic connecting to the game client
- Added API and CLI interface for the service
