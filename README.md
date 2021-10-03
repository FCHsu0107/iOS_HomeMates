# HomeMates   

HomeMates is a mobile application in the iOS platform for records of housework that allows family members to participate in housework through interactive tasks.

HomeMates 是一款家事紀錄的 iOS 應用程式，透過任務的互動形式讓家庭成員參與家庭事務。

![](https://i.imgur.com/4HsikIz.png)

This App was launched in App Store on April 2019 and is currently not available.
此應用程式於 2019 四月在 App Store 上架，現在已不開放下載。

<img src="https://github.com/nick1ee/Shalk/raw/master/screenshot/DownloadAppStoreBadge.png" width="160" height="50" align=center>


```
There is no API key in source code. 
If you would like to build the project, please
1. create a new project in Google Firebase
2. add the file "GoogleService-Inf.plist" in the project

程式碼無包含 API Key，若需執行下載專案，請自行建立 Google Firebase 專案。
下載新建專案的 GoogleService-Inf.plist。
```

## Features 


- Group 群組功能

    - The system for login and registration 登入/註冊系統

        <img src="https://i.imgur.com/c0c5chr.gif" width="200"  align=center>

    - Manage housework on a group(one family) basis in cloud services. Users can log in and manage data on different iOS devices.
    以群組為單位並以雲端服務管理群組事務，可從不同 iOS 裝置登入獲取及管理資料。
    
- Establish tasks mechanism: 
  **Post tasks, Accept tasks and Confirm completion of tasks**
  建立任務機制： **發佈任務**、**接取任務**、**確認完成任務**

  - Post tasks: members can post a task in a group and then other members get a notification to know current tasks.
  發布任務：讓群組成員了解當前的家庭事務。

  - Accept tasks: members accept the task they want to conduct.
  接取任務：成員可主動認領家庭事務。

  - Confirm completion of tasks: publishers can confirm the status of tasks. The executor gets the points after the publisher clicks a confirm button.
  確認完成任務：透過其他成員確認任務獲取積分。
  
    <img src="https://i.imgur.com/SiHKhhk.gif" width="200"  align=center> <img src="https://i.imgur.com/auEFPfI.gif" width="200"  align=center> <img src="https://i.imgur.com/v8059eZ.gif" width="200"  align=center> 



- Daily Tasks 每日任務

    - Set up routine tasks: routine will be added automatically every day.
  設定每日任務列表: 每天登入後任務會自動添加至可接取任務列表。


- Points system 積分制度
  
  - Each member can set a goal every month, and achieve the goal by complete tasks.
  每月成員可自行訂定目標，透過接取任務達成每月目標。
  
      <img src="https://i.imgur.com/a3HGSwz.gif" width="200"  align=center>

  
- Statistics 任務紀錄

 
   - Review the past tasks completed by the group, track past executors and completion dates.
   回顧群組過往完成任務，追蹤過去的執行者及完成日期。
   
        <img src="https://i.imgur.com/oOFNeC7.gif" width="200"  align=center>  <img src="https://i.imgur.com/KjSW80r.gif" width="200"  align=center> 
  - View the goal achievement rate of group members.
   瀏覽群組成員的目標達成率。
 

## Libraries

- Firebase as a backend management platform, including the following items

  - Authentication：管理使用者帳戶資訊。
  
  - Database - Firestore：管理任務、群組、過往紀錄及詳細個人資訊。
  
  - Crashlytics：確保 App 使用品質，發生當機現象時可針對有問題程式法修復，提供更好的使用體驗。
  
  - Analytics：蒐集使用者使用行為模式，作為優化新增功能的分析依據之一。
  - Messaging：建立推播系統 (**Remote Push Notifications**)，增加群組成員間的互動。

- SwiftLint：建立良好的編碼習慣。

- MJRefresh

- FSCalendar

- SwiftMessages

## Requirements

- iOS 11.0+

- Xcode 10.0+

## Versions

- 1.1.1 - 2019/05/15

  - Updated layout 更新使用者介面

  - Added the feature of notification 新增推播功能

  - Added the feature of leaving the group 新增退出群組功能

- 1.1 - 2019/05/03

  - Updated layout 更新使用者介面

  - Optimized user experience 優化使用者體驗

- 1.0.3 - 2019/04/30

  - Launched 初版上架

## Contact

   Fu Chiung Hsu

   hsufuchiung@gmail.com
