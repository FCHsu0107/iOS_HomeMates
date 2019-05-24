# HomeMates   

HomeMates 是一款家事紀錄的 App ，透過任務的互動形式讓家庭成員參與家庭事務。

![](https://i.imgur.com/4HsikIz.png)

程式碼無包含 API Key，若要體驗 App 完整功能請至 App Store 下載。

[<img src="https://github.com/nick1ee/Shalk/raw/master/screenshot/DownloadAppStoreBadge.png" width="160" height="50" align=center>](https://itunes.apple.com/us/app/homemates/id1461736657?l=zh&ls=1&mt=8)

```
若需執行下載專案，請自行建立 Google Firebase 專案。
下載新建專案的 GoogleService-Inf.plist。
```

## Features 


- 群組功能

    - 登入/註冊系統

    <img src="https://i.imgur.com/c0c5chr.gif" width="200"  align=center>


    - 以群組為單位雲端管理群組事務，可從不同 iOS 裝置登入獲取及管理資料。

- 建立任務機制： **發佈任務**、**接取任務**、**確認完成任務**

- 發布任務：讓群組成員了解當前的家庭事務。

- 接取任務：成員可主動認領家庭事務。
- 確認完成任務：透過其他成員確認任務獲取積分。

    <img src="https://i.imgur.com/SiHKhhk.gif" width="200"  align=center> <img src="https://i.imgur.com/auEFPfI.gif" width="200"  align=center> <img src="https://i.imgur.com/v8059eZ.gif" width="200"  align=center> 



- 每日任務

-  設定每日任務列表，每天登入後任務會自動添加至可接取任務列表。


- 積分制度

- 每月成員可自行訂定目標，透過接取任務達成每月目標。

<img src="https://i.imgur.com/a3HGSwz.gif" width="200"  align=center>


- 任務紀錄

   - 回顧群組過往完成任務，追蹤過去的執行者及完成日期。
   
        <img src="https://i.imgur.com/oOFNeC7.gif" width="200"  align=center>  <img src="https://i.imgur.com/KjSW80r.gif" width="200"  align=center> 
 
   - 瀏覽群組成員的目標達成率。
 
- 回顧群組過往完成任務，追蹤過去的執行者及完成日期。

<img src="https://i.imgur.com/oOFNeC7.gif" width="200"  align=center>  <img src="https://i.imgur.com/KjSW80r.gif" width="200"  align=center> 

- 瀏覽群組成員的目標達成率。


## Libraries

- Firebase 作為 App 的後端管理平台，包含

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

- Xcode 10.2+

## Versions

- 1.1.1 - 2019/05/15

- UI 更新

- 新增推播功能

- 新增退出群組功能

- 1.1 - 2019/05/03

- UI 更新

- 優化使用者體驗

- 1.0.3 - 2019/04/30

- 初版上架

## Contact

Fu Chiung Hsu

hsufuchiung@gmail.com
