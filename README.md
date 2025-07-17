### Automate project creation with create-ios-app.sh


create-ios-app.sh bash script automates UIKit project creation with opinionated defaults:
1. Minimum iOS version: 13.0
2. "Debug executable" is disabled when a project is created
3. An empty repo is initialized with some .gitignored files
4. Initial git commit is created

To create a project, simply run `sh create-ios-app.sh 'my app'` with the name of your app (instead of 'my app')
When a project is created for the first time, it's going to ask you for your organization identifier, which you can usually find when you press "command + Shift + N" to create a new project, select project type, hit "Next" and see the project's options:
<img width="738" height="530" alt="image" src="https://github.com/user-attachments/assets/fca6d456-5277-414b-b7d0-01480e93662c" />

Here you might see an example output of the `sh create-ios-app.sh 'my app'` command:
<img width="701" height="236" alt="image" src="https://github.com/user-attachments/assets/459ce064-2627-47fd-849d-3d5d3e5e60ea" />
