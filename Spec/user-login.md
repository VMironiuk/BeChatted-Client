# User Login

## User Login Feature Spec

### Story: User requests a user login

### Narrative #1

```
As an online user
I want to login to the app
So I can use the app to send/read messages, create channels etc.
```

#### Scenarions (Acceptance criteria)

```
Given the user has connectivity
 Wnen the user requests a user login
  And the specified email and password are valid
  And there is a user with given email and password registered
 Then the user can send/read messages, create channels etc.

Given the user has connectivity
 Wnen the user requests a user login
  And the specified email and password are valid
  And there is no user with given email or password registered
 Then the app should display an error message

Given the user has connectivity
 Wnen the user requests a user login
  And the specified email and password are valid
  And there is an issue with the server
 Then the app should display an error message

Given the user has connectivity
 Wnen the user is typing email and password to login
  And the specified email or password are invalid
 Then the app should display an error message
  And there should no possibility to send a login reqeust
```

### Narrative #2

```
As an offline user
I cannot login into the app
```

#### Scenarios (Acceptance criteria)

```
Given the user has no connectivity
 Wnen the user requests a user login
 Then the app should display an error message
```

## Use Cases

### User Login Use Case

#### Data:
- URL
- User Email
- User Password

#### Primary course (happy path):
1. Execute "User Login" command with above data.
2. System sends a request to the server.
3. System gets a response from the server.
4. System validates the response from the server.
5. System takes a token from the response
6. System allows the user to enter the application.

#### Invalid data - error course (sad path);
1. System delivers invalid data error.
2. System does not allow to send a request to the server.

#### Email and/or password does not exist - error course (sad path);
1. System delivers invalid credentials error.
2. System does not allow to enter the application.

### Non 200 HTTP response - error course (sad path):
1. System delivers unknown error.

#### No connectivity - error course (sad path):
1. System delivers no connectivity error.
2. System does not allow to send a request to the server.

## Model Specs

### User Login Credentials

| Property      | Type                |
|---------------|---------------------|
| `email`       | `String`            |
| `password`    | `String`            |

### Payload contract

```
POST /v1/account/login

{
  "email": "example@email.com",
  "password": "123456" 
}

200 RESPONSE

{
  "user": "<USER>",
  "token": "<ACCESS_TOKEN>"
}

409 RESPONSE

{
  "message": "An error occured: <error_message>"
}

401 RESPONSE

{
  "message": "Email or password invalid, please check your credentials"
}
```
