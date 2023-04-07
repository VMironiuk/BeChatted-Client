# User Logout

## User Logout Feature Spec

### Story: User requests a user logout

### Narrative #1

```
As an online user
I want to logout from the app
So I do not see channels, messages etc., and need to login again to use the app
```

#### Scenarions (Acceptance criteria)

```
Given the user has connectivity
 Wnen the user requests a user logout
 Then the app logouts the user regardless of the response
```

### Narrative #2

```
As an offline user
I can logout from the app
```

#### Scenarions (Acceptance criteria)

```
Given the user has no connectivity
 Wnen the user requests a user logout
 Then the app logouts the user regardless of the response 
  And delivers the connectivity error
```

## Use Cases

### User Logout Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "User Logout" command with above data.
2. System sends a request to the server.
3. System allows the user to logout from the application regardless of the response.

#### No connectivity - error course (sad path):
1. System allows the user to logout from the application.
1. System delivers no connectivity error.

### Payload contract

```
GET /v1/account/login

200 RESPONSE

"Successfully logged out"

NOTE: Client can not rely on the response
```