# Add user

## Add User Feature Spec

### User requests to add a user

### Narrative #1

```
As an online user
I want to add a user to the system through the app
So I can use this user to auth to the system in the future
```

#### Scenarios (Acceptance criteria)

```
Given the user has connectivity
 Wnen the user requests to add a new user to the system
  And the specified email and password are valid
  And the auth token is valid
 Then the user can add a new user to the system

Given the user has connectivity
 Wnen the user requests to add a new user to the system
  And the specified email and password are valid
  And the auth token is valid
  And there is an issue with the server
 Then the app should display an error message

Given the user has connectivity
 Wnen the user requests to add a new user to the system
  And the specified email and password are invalid
  And the auth token is valid
 Then the app should display an error message
  And there should no possibility to send the request

Given the user has connectivity
 Wnen the user requests to add a new user to the system
  And the specified email and password are valid
  And the auth token is invalid
 Then the app should display an error message
```

### Narrative #2

```
As an offline user
I cannot add a new user to the system
```

#### Scenarios (Acceptance criteria)

```
Given the user has no connectivity
 Wnen the user requests to add a new user to the system
 Then the app should display an error message
```

## Use Cases

### Add User Use Case

#### Data:
- URL
- Name
- Email
- Avatar Name
- Avatar Color

#### Primary course (happy path):
1. Execute 'Add User' command with above data.
2. System sends a request to the server.
3. System gets a response from the server.
4. System validates the response from the server.
5. User is added to the system

#### Invalid data - error course (sad path);
1. System delivers invalid data error.

### Non 200 HTTP response - error course (sad path):
1. System delivers server error.

#### No connectivity - error course (sad path):
1. System delivers no connectivity error.

## Model Specs

### User to Add

| Property      | Type                |
|---------------|---------------------|
| `name`        | `String`            |
| `email`       | `String`            |
| `avatarName`  | `String`            |
| `avatarColor` | `String`            |

### Payload contract

```
POST /v1/user/add

{
  "name": "user name",
  "email": "example@email.com",
  "avatarName": "<AVATAR_NAME>",
  "avatarColor": "<AVATAR_COLOR>"
}

200 RESPONSE

{
  "name": "user name",
  "email": "example@email.com",
  "avatarName": "<AVATAR_NAME>",
  "avatarColor": "<AVATAR_COLOR>"
}

500 RESPONSE

{
  "message": "<error_message>"
}
```