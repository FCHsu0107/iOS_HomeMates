# HomeMates   
HomeMates is a cloud-based household management iOS application with essential features for managing domestic tasks. These features include group management, task assignment, point-based rewards, and data visualization.

![](https://i.imgur.com/4HsikIz.png)

This App was launched in the App Store in April 2019 and is currently unavailable.
<img src="https://github.com/nick1ee/Shalk/raw/master/screenshot/DownloadAppStoreBadge.png" width="160" height="50" align=center>


```
There is no API key in the source code. 
If you would like to build the project, please
1. create a new project in Google Firebase
2. add the file "GoogleService-Inf.plist" in the project
```

## Technologies
Swift 
Notification center
Firebase
Unit Testing

## Key Features 


- Group 

    - The system for login and registration 

        <img src="https://i.imgur.com/c0c5chr.gif" width="200"  align=center>

    - Manage housework on a group(one family) basis in cloud services. Users can log in and manage data on different iOS devices.
- Establish tasks mechanism: 
  **Post tasks, Accept tasks, and Confirm completion of tasks**

  - Post tasks: members can post a task in a group and then other members get a notification to know current tasks.

  - Accept tasks: members accept the task they want to conduct.

  - Confirm completion of tasks: publishers can confirm the status of tasks. The executor gets the points after the publisher clicks the confirm button.
  
    <img src="https://i.imgur.com/SiHKhhk.gif" width="200"  align=center> <img src="https://i.imgur.com/auEFPfI.gif" width="200"  align=center> <img src="https://i.imgur.com/v8059eZ.gif" width="200"  align=center> 



- Daily Tasks 

    - Set up routine tasks: routine will be added automatically every day.

- Points system
  
  - Each member can set a goal every month, and achieve the goal by completing tasks.
  
      <img src="https://i.imgur.com/a3HGSwz.gif" width="200"  align=center>

  
- Statistics

 
   - Review the past tasks completed by the group, and track past executors and completion dates.
   
        <img src="https://i.imgur.com/oOFNeC7.gif" width="200"  align=center>  <img src="https://i.imgur.com/KjSW80r.gif" width="200"  align=center> 
  - View the goal achievement rate of group members.
 

## Libraries

- Firebase as a backend management platform, including the following items

  - Authentication: Manage user account information.
  - Database - Firestore: Manage tasks, groups, past records, and detailed personal information.
  - Crashlytics: Ensures the quality of the app. When a crash occurs, problematic programs can be repaired to provide a better user experience.
  - Analytics: Collect user behavior patterns as one of the analysis bases for optimizing new features.
  - Messaging: Establish a push notification system (**Remote Push Notifications**) to increase interaction among group members.

- SwiftLint
- MJRefresh
- FSCalendar
- SwiftMessages

## Requirements

- iOS 11.0+

- Xcode 10.0+

## Versions

- 1.1.1 - 2019/05/15

  - Added the feature of notification 

  - Added the feature of leaving the group 

- 1.1 - 2019/05/03

  - Optimized user experience

- 1.0.3 - 2019/04/30

  - Launched

## Contact

   Fu Chiung Hsu

   hsufuchiung@gmail.com
