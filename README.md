[![Platform](https://img.shields.io/cocoapods/p/QRCode.svg?style=flat)](#)
[![Swift](https://img.shields.io/badge/swift-5.1-orange.svg?style=flat)](https://developer.apple.com/swift)

# WTest iOS Test

## Instructions:
- Open `WTest.xcodeproj` on Xcode (was developed on version `13.2.1`);
- Build on simulator

## If want to buil on device (recomended):
- Signing & Capabilities;
- Select a Team;
- Run

--------------------------

## Functions:
- First launch:
  - Request CSV online
  - If Success, save values localy using Core Data;
  - If Failure, alert showing the respective error, like network offline or problem parsing the object.
- Second launch:
  - Get values directly from DB

## Parsing
Used `Swift CSV 0.6.1` via **Swift Package Manager** to parse the downloaded file.

To install/update: `File -> Packages -> Update to Latest Package Version`

## Decisions:
- MVVM Architechture
- Core Data
- Search DB
- Button to **Reset DB and Force Fetch** for convenience 
- Tests (todo)

## Todo:
- [ ] Detail screen to view all data about the selected entry
- [ ] UnitTest
- [ ] UITest
- [ ] Check iPad layout or remove, leaving just iPhone
