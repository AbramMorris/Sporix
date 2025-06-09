# Sporix - iOS Sports App 🏆

[![Swift Version](https://img.shields.io/badge/Swift-5.7-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-15-blue.svg)](https://developer.apple.com/xcode/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 📖 Project Overview

**Sporix** is an elegant iOS application that provides comprehensive information about various sports, leagues, and teams, powered by the [AllSportsAPI](https://allsportsapi.com/).  
The app leverages modern iOS components, uses **Alamofire** for networking, and **CoreData** for local data persistence to offer a smooth, user-friendly experience.

---

## 🚀 Features

### Main Screen - Two Tabs
- **Sports Tab**  
  - Displays sports in a two-column `UICollectionView` with thumbnails and names.  
  - Selecting a sport navigates to the Leagues screen.

- **Favorites Tab**  
  - Shows favorite leagues stored using CoreData.  
  - Tapping a league opens the details if online, else displays a no-internet alert.

### Leagues ViewController
- UITableView listing leagues with circular badges and league names.  
- Selecting a league navigates to `LeagueDetailsViewController`.

### LeagueDetails ViewController
- Add/remove league to favorites using a button on the top-right.  
- Divided into three sections:  
  1. Upcoming Events (horizontal `UICollectionView`)  
  2. Latest Events (vertical `UICollectionView`)  
  3. Teams (horizontal `UICollectionView` with circular images)  
- Tapping a team leads to TeamDetails.

### TeamDetails ViewController
- Displays selected team details with an elegant, clean UI.
 
### Other
- Onboarding screens for first-time users  
- Dark mode support  
- Localization for multiple languages  
---

## 🛠️ Technologies Used

- **Language:** Swift 5.7+  
- **Architecture:** MVP with clear separation of concerns  
- **Networking:** [Alamofire](https://github.com/Alamofire/Alamofire)  
- **Persistence:** CoreData for favorites storage  
- **API:** [AllSportsAPI](https://allsportsapi.com/)  
- **UI:** UIKit with AutoLayout constraints for responsive design  
- **Testing:** Unit tests for networking and data layers  

---

## 👥 Team Members 

| Name          | 
|---------------|
| Abram Morris  | 
| Youssef Fayad | 

---

## 🚀 How to Run

1. Clone the repo:  
   ```bash
   git clone https://github.com/AbramMorris/Sporix.git
