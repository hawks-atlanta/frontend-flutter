# CapyApp Guidelines

This document describes how to structure your code so it can couple with the other developers contributing to it.

## Repository Pattern

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
