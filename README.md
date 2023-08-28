# login_mobile | Capylogin_mobile

## Description

| File                                                     |
| -------------------------------------------------------- |
| [GoRoute & Riverpod](./assets/GoRoute.md)                |
| [Context within architecture ](./assets/Architecture.md) |
| [Mockups](./assets/Mockups.md)                           |
| [Mockups production](./assets/MockupsProduction.md)      |

## Development

You will follow this guide as you are in the root of repository.

### Folder structure

| Folder                             | Description                                                  |
| ---------------------------------- | ------------------------------------------------------------ |
| `lib/config`                       | It contains constants, application routes (using **GoRoutes**), and themes using **Material** & **google_fonts**. |
| `lib/features/auth/domain`         | It contains the entire domain model, along with the datasource, entities, and repositories. |
| `lib/features/auth/infrastructure` | It contains the **datasources**, which are the current functions of the app, error **customizations**, User mappers, and repository implementation. |
| `lib/features/auth/presentation`   | The presentation layer, providers, and screens are included here, and you can also create custom widgets within it. |
| `lib/features/drive`               | It contains the main views layer of CapyFile APP.            |
| `lib/features/shared`              | It contains functions and classes that are shared across multiple layers, and you can also create custom widgets here that you want to use throughout the app. |

### Rest API

To deploy this application, a connection to a backend service is required. It's necessary to view the implementation under the [Domain](#domain-structure-using-repository-pattern) model.

### Create .env

``````
API_LOGIN_URL = http://IP-LOCALHOST-OR-API:PORT
``````

### Flutter Environment

*"Some packages are missing or out of date, would you like to get them now?"*

If you get this advertisement or if you don't get it, you should run the command, to install pub packages:

``````bash
pub get
``````

- Check the `pubspec.yaml`

- Check the`assets`

  <u>Select your Simulator and start app</u>

---

## Domain Structure using *Repository Pattern*

CapyFile Mobile can change the domain model without having to make many changes in the code thanks to the **repository** **pattern**, to generate the changes always take into account the response to the api that is being consumed with their respective responses.

Example user entities of (*login,register,checkAuth*):

``````dart
class User {
  final String uuid;
  final String username;
  final int statusCode;
  final String message;
  final String token;

  User({
    required this.uuid,
    required this.username,
    required this.statusCode,
    required this.message,
    required this.token,
  });
}
``````

This example is when such an API is consumed:

``````json
{
    "uuid": "d63c73f1-ce3e-4f0f-b724-c7be323b0851",
    "message": "Authentication successful",
    "statusCode": 200,
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRob3JpemVkIjp0cnVlLCJleHAiOjE2OTMxMTA4MDEsInVzZXJuYW1lIjoic2FudGlhZ28iLCJ1dWlkIjoiZDYzYzczZjEtY2UzZS00ZjBmLWI3MjQtYzdiZTMyM2IwODUxIn0.dgpavfGNww5iWdilLryfi66mR6i3Yoiq7KnrhT7R0KU",
    "username": "santiago"
}
``````

## .env using *([Adapter Pattern](https://refactoring.guru/es/design-patterns/adapter)*)

Uses an adapter pattern to handle in a more friendly way the .env, for this an Environment class was built so that it can be consumed by calling the class and the corresponding variable. Example of use: `Enviroment.apiURL` apiURL is your var .env.

## Endpoints

Currently consumes 2 endpoints for authentication, `/login` and ` /check-status` , also has the start to develop the consumption of an endpoint for `/register`

*check-status:* CapyFile App goes through **Bearer Token** every time you need to log in to check if the token you have stored using shared preferences is valid, this API would respond something like the following:

``````json
{
    "message": "Token is valid",
    "statusCode": 200,
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRob3JpemVkIjp0cnVlLCJleHAiOjE2OTMxMDgxNjYsInVzZXJuYW1lIjoic2FudGlhZ28iLCJ1dWlkIjoiZDYzYzczZjEtY2UzZS00ZjBmLWI3MjQtYzdiZTMyM2IwODUxIn0.p5F2tS6MR7CAW2e9HMS9qv3ol9vgDejneshlQfEbFZ4",
    "username": "santiago",
    "uuid": "d63c73f1-ce3e-4f0f-b724-c7be323b0851"
}
``````

or

``````json
{
    "error": "Unauthorized",
    "statusCode": 401
}
``````

## Possible normal mistakes

<img src="./assets/image-20230827000729799.png" alt="image-20230827000729799" />

This error normally occurs in Flutter, when you want to work with APIs that are outside the same emulator, to solve this add your IPV4 in `.env` 
