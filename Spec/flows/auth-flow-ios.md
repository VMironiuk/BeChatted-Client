## Auth Flow (iOS)

### Login Screen UI

- app logo
- email text field
- password text field
- login button (inactive until an user enters email and password in valid format)
- register/create account/sign up button (active)

### Use Cases

Valid credentials (Happy Path)
1. An user runs the iOS app
2. The app shows the `Login` screen
3. The user enters valid credentials
4. Tha app turns the `Login` button to active state
5. The user taps the `Login` button
6. The app shows the main screen

Invalid email format, valid password length or valid password (Sad path)
1. An user runs the iOS app
2. The app shows the `Login` screen
3. The user enters email in invalid format
4. The user taps on the password text field
5. The user enters valid apssword or password with valid length
6. Tha app turns the `Login` button to active state
7. The user taps the `Login` button
5. The app shows an error ribbon on the `Login` screen, clears text fields, and turns the login button to inactive state

Invalid email but valid email format, valid password length or valid password (Sad path)
1. An user runs the iOS app
2. The app shows the `Login` screen
3. The user enters invalid email in valid email format
4. The user taps on the password text field
5. The user enters valid password or password with valid length
6. The app turns the `Login` button to active state
7. The user taps the `Login` button
8. Tha app shows an error ribbon on the `Login` screen, clears text fields, and turns the login button to inactive state

Invalid email format, invalid password length (Sad path)
1. An user runs the iOS app
2. The app shows the `Login` screen
3. The user enters email in invalid format
4. The user taps on the password text field
5. The user enters password with invalid length
6. Tha app doesnot activate the `Login` button until the user enters pawwsord with valid length

Invalid email format, invalid password but valid password length (Sad path)
1. An user runs the iOS app
2. The app shows the `Login` screen
3. The user enters email in invalid format
4. The user taps on the password text field
5. The user enters invalid password with valid length
6. Tha app turns the `Login` button to active state
7. The user taps the `Login` button
8. Tha app shows an error ribbon on the `Login` screen, clears text fields, and turns the login button to inactive state

Invalid email but valid email format, invalid password but valid password length (Sad path)
1. An user runs the iOS app
2. The app shows the `Login` screen
3. The user enters invalid email in valid email format
4. The user taps on the password text field
5. The user enters invalid password but valid password length
6. Tha app turns the `Login` button to active state
7. The user taps the `Login` button
8. Tha app shows an error ribbon on the `Login` screen, clears text fields, and turns the login button to inactive state

Invalid email but valid email format, invalid password length (Sad path)
1. An user runs the iOS app
2. The app shows the `Login` screen
3. The user enters invalid email in valid email format
4. The user taps on the password text field
5. The user enters password with invalid password length
6. Tha app doesnot activate the `Login` button until the user enters pawwsord with valid length

Valid email, invalid password but valid password length (Sad path)
1. An user runs the iOS app
2. The app shows the `Login` screen
3. The user enters valid email
4. The user taps on the password text field
5. The user enters invalid password but valid password length
6. Tha app turns the `Login` button to active state
7. The user taps the `Login` button
8. Tha app shows an error ribbon on the `Login` screen, clears text fields, and turns the login button to inactive state

Valid email, invalid password length (Sad path)
1. An user runs the iOS app
2. The app shows the `Login` screen
3. The user enters valid email
4. The user taps on the password text field
5. The user enters password with invalid password length
6. Tha app doesnot activate the `Login` button until the user enters pawwsord with valid length

### Register Screen UI

- app logo
- name text field
- email text field
- password text field
- register/sign up button (inactive until an user enters name, email, and password in valid format)
- login/sign in up button (active)

### Use Cases

The same as for the `Login` screen because `name` doesn't have constraints