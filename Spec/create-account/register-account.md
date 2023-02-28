# Register account

## Account Registration Feature Spec

### Story: User requests a new account registration

### Narrative #1

```
As an online user
I want to register a new account
So I can login later with new account credentials
```

#### Scenarios (Acceptance criteria)

```
Given the user has connectivity
 When the user requests a new account registration
  And the specified email and password are valid
  And there is no account registered with the same email
 Then the user can login with new account credentials

Given the user has connectivity
 When the user requests a new account registration 
  And the specified email and password are valid
  And there is an account registered with the same email
 Then the app should display an error message

Given the user has connectivity
 When the user requests a new account registration
  And the specified email and password are valid
  And there is an issue with the server
 Then the app should display an error message

Given the user has connectivity
 When the user requests a new account registration
  And the specified email or password is/are not valid
 Then the app should display an error message
  And there should no possibility to send a regstration reqeust
```

### Narrative #2

```
As an offline user
I cannot register a new account
```

#### Scenarios (Acceptance criteria)

```
Given the user has no connectivity
 Then the app should display an error message
  And there should no possibility to send a registration request
```

## Use Cases

### Register a New Account Use Case

#### Data:
- URL
- User Email
- User Password

#### Primary course (happy path):
1. Execute "Register New Account" command with above data.
2. System sends a request to the server.
3. System gets a response from the server.
4. System validates the response from the server.
5. System shows a message about successful registration on the valid server response.

#### Invalid data - error course (sad path);
1. System delivers invalid data error.
2. System does not allow to send a request to the server.

### Non 200 HTTP response - error course (sad path):
1. System delivers a message from the server.

#### No connectivity - error course ():
1. System delivers no connectivity error.
2. System does not allow to send a request to the server.

## Model Specs

### Account to Register

| Property      | Type                |
|---------------|---------------------|
| `email`       | `String`            |
| `password`    | `String`            |

### Payload contract

```
POST /v1/account/register

{
  "email": "example@email.com"
  "password": "123456" 
}

200 RESPONSE

"Successfully created new account"

409 RESPONSE

{
  "message": "An error occured: <error_message>"
}

300 RESPONSE

{
  "message": "Email <email> is already registered"
}

500 RESPONSE

{
  "message": "<error_message>"
}
```
