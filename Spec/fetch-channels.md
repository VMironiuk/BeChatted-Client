# Fetch channels feature

## Fetch Channels Feature Spec

### User Requests to Fetch Channels

### Narrative 1

```
As an online user
I want to fetch channels
So I can see the list of channels in the app
```

### Scenarios (Acceptance criteria)

```
Given the user has connectivity
 When the user enters the channels screen for the first time (after succesfull login)
  And there are cahnnels in the system
 Then the app shows the list of channels on the screen

Given the user has connectivity
 When the user enters the channels screen for the first time (after succesfull login)
  And there are no cahnnels in the system
 Then the app shows information or the empty channels list

Given the user has connectivity
 When the user enters the channels screen for the first time (after succesfull login)
  And there is an issue with the server
 Then the app shows a error message

Given the user has connectivity
  And the user enters the channels screen not for the first time
 Then the app shouldn't refresh the list of channels

Given the user has connectivity
  And the user enters the channels screen not for the first time
  And the user refreshes the list of channels
  And there are cahnnels in the system
 Then the app shows the refreshed list of channels on the screen

Given the user has connectivity
  And the user enters the channels screen not for the first time
  And the user refreshes the list of channels
  And there are no cahnnels in the system
 Then the app shows information or the empty channels list

Given the user has connectivity
  And the user enters the channels screen not for the first time
  And the user refreshes the list of channels
  And there is an issue with the server
 Then the app shows a error message
```

### Narrative 2

```
As an offline user
I cannot fetch channels from the server
```

### Scenarios (Acceptance criteria)

```
Given the user has no connectivity
 When the user enters the channels screen for the first time (after succesfull login)
 Then the app shows the connectivity error message

Given the user has no connectivity
  And the user enters the channels screen not for the first time
  And the user refreshes the list of channels
 Then the app shows the connectivity error message
```

## Use Cases

### Fetch Channels Case

#### Data
- URL

#### Primary course (happy path)
1. Execute 'Fetch Channels' command with the above data
2. The system sends the request to the server
3. The system gets the response from the server
4. The system validates the response from the server
5. The system shows the list of channels or empty list with some info if there are no channels

#### Invalid data error - error course (sad path)
1. The system delivers invalid data error

#### Non 200 HTTP response - error course (sad path)
1. The system delivers server error

#### No connectivity - error  course (sad path)
1. The system delivers no connectivity error

## Model Specs

### Channel

| Property      | Type                |
|---------------|---------------------|
| `_id`         | `String`            |
| `name`        | `String`            |
| `description` | `String`            |

### Payload contract

```
GET /v1/channel

[
    {
       "_id": "0123456789",
        "name": "a name",
        "description": "a description"
    }
]

200 RESPONSE

[
    {
        "_id": "0123456789",
        "name": "a name",
        "description": "a description"
    }
]

500 RESPONSE

{
  "message": "<error_message>"
}
```
