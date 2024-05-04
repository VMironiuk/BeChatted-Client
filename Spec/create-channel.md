# Create a channel feature

## Create a Channel Feature Spec

### User Requests Create a Channel

### Narrative 1

```
As an online user
I want to create a channel
So I can see this channel in the list of channels
And I can use this channel for further communication
```

### Scenarios (Acceptance criteria)

```
Given the user has connectivity
 When the user goes through creating a chanel flow
  And the user hits `Create channel` button
  And server creates new channel
 Then the app redirects to new channel (or doesn't redirect)

  Given the user has connectivity
 When the user goes through creating a chanel flow
  And the user hits `Create channel` button
  And server cannot create a channel
 Then the app shows server error
```

### Narrative 2

```
As an offline user
I cannot create a channel on the server
```

### Scenarios (Acceptance criteria)

```
Given the user has no connectivity
 When the user goes through creating a chanel flow
  And the user hits `Create channel` button
 Then the app shows connectivity error
```

## Use Cases

### Create a Channel Case

#### Data
- URL
- Channel name
- Channel description

#### Primary course (happy path)
1. Execute 'Create a Channel' command with the above data
2. The system sends the request to the server
3. The system gets the response from the server
4. The system validates the response from the server
5. The system redirects to the newly created channel (or doesn't redirect?)

#### 500 HTTP response - error course (sad path)
1. The system delivers server error

#### No connectivity - error  course (sad path)
1. The system delivers no connectivity error

## Model Specs

### Channel

| Property      | Type                |
|---------------|---------------------|
| `name`        | `String`            |
| `description` | `String`            |

### Payload contract

```
POST /v1/channel/add

{
    "name": "a name",
    "description": "a description"
}

200 RESPONSE

{ 
    message: 'Channel saved successfully' 
}

500 RESPONSE

{ 
    message: "<error_message>" 
}
```