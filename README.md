# CapyApp

[![Release](https://github.com/hawks-atlanta/frontend-flutter/actions/workflows/release.yaml/badge.svg)](https://github.com/hawks-atlanta/frontend-flutter/actions/workflows/release.yaml)
[![Tagging](https://github.com/hawks-atlanta/frontend-flutter/actions/workflows/tagging.yaml/badge.svg)](https://github.com/hawks-atlanta/frontend-flutter/actions/workflows/tagging.yaml)
[![Test](https://github.com/hawks-atlanta/frontend-flutter/actions/workflows/testing.yaml/badge.svg)](https://github.com/hawks-atlanta/frontend-flutter/actions/workflows/testing.yaml)

## Documentation

| Document             | URL                                                                                                                                                                      |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| CICD                 | [CICD.md](https://github.com/hawks-atlanta/docs/blob/main/CICD.md)                                                                                                       |
| CONTRIBUTING         | Make sure you first read [CONTRIBUTING.md](https://github.com/hawks-atlanta/docs/blob/main/CONTRIBUTING.md) and then, this project's [GUIDELINES.md](docs/GUIDELINES.md) |
| Mockups              | [Mockups.md](./docs/Mockups.md)                                                                                                                                          |
| Mockups (production) | [MockupsProduction.md](./docs/MockupsProduction.md)                                                                                                                      |
| Routing              | [Routing.md](docs/Routing.md)                                                                                                                                            |

## Repository structure

| Folder                             | Description                                                                                                                                                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `lib/config`                       | It contains constants, application routes (using **GoRoutes**), and themes using **Material** & **google_fonts**.                                              |
| `lib/features/auth/domain`         | It contains the entire domain model, along with the datasource, entities, and repositories.                                                                    |
| `lib/features/auth/infrastructure` | It contains the **datasources**, which are the current functions of the app, error **customizations**, User mappers, and repository implementation.            |
| `lib/features/auth/presentation`   | The presentation layer, providers, and screens are included here, and you can also create custom widgets within it.                                            |
| `lib/features/drive`               | It contains the main views layer of CapyFile APP.                                                                                                              |
| `lib/features/shared`              | It contains functions and classes that are shared across multiple layers, and you can also create custom widgets here that you want to use throughout the app. |

## Development

- Make sure you setup the application backend by running:

```shell
docker compose up -d
```

This will expose `0.0.0.0:8080` with a running REST API service on your machine.

- Then configure the **`.env`** file in the root of this repository with the IP of your machine on your local network (so your Android phone or emulator can reach the service)

  _Note: check whether it's **HTTP** or HTTPS with the service's port address provided by the proxy; it should be HTTP for it to work in Flutter._

```shell
echo 'API_URL="http://IP_OF_YOUR_COMPUTER:PORT"' > env
```

- Install flutter dependencies with:

```shell
flutter pub get
```

- Finally compile and copy (or hot-reload) the binary to your phone/emulator
