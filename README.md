# **iOS Tracker Framework**

An open source iOS framework to record, store and upload activity data. These data are captured through device sensors, they're stored into a Realm database and cyclically uploaded to a remote server

| Documentation                 |
|-------------------------------|
| [Requirements](#requirements) |
| [Setup](#setup)               |
| [Integration](#integration)   |
| [Configuration](#configuration)   |
| [Usage](#usage)           |
| [Known Issues](#known-issues)       |
| [License](#license)           |
| [Copyright](#copyright)       |

## Requirements

- xCode (14 or later)
- Cocoapods (1.12.1 or later)
- iOS (12.0 or later)

The tracker framework needs these pods to be included into the host application workspace

```swift
pod 'Alamofire', '= 5.7.1'
pod 'RealmSwift', '= 10.40.2'
```

## Setup

- Clone the framework repository
- Open the terminal on the project root folder and run `pod install`
- Open the *tracker.xcworkspace* file
- Select the required target from the list next to the schema (Emulator vs Device)
- Clean and Build the project

## Integration

- Reveal in finder the generated framework file at path *Tracker/Products/Tracker.framework*
- Copy/Cut and paste the framework file into the host application root folder
- Drag the framework file from the root folder to the host application project below:
    - Target
    - General
    - Frameworks, libraries, and Embedded Content
- Select the *Embed & Sign* option from the dropdown on the right
- Install the required pods
- Clean and Build the project
- Use the new generated file below the Product folder

## Configuration

### Import

This import must be set in every class where any of the tracker resources are used

```swift
import Tracker
```

### Configure

These are the default tracker configurations that can be customized. If they're not set, the tracker will use the default ones

```swift
let config = TrackerConfig()
config.logLevel = .LOW
config.minimumSegmentDuration = 120
config.stepsPerSecondThreshold = 0.2
config.stepsPerBriskMinuteThreshold = 96
config.locationTrackingEnabled = true
config.intensityEnabled = true
config.stepsEnabled = true
config.cyclingEnabled = true
config.automotiveEnabled = true
config.wifyAnalysisEnabled = true
config.dataUploadEnabled = true
config.useLegacyDataUpload = false
config.userRegistrationEnabled = false
config.useLegacyUserRegistration = false
TrackerManager.config = config
```

### User Registration

The tracker provides an api to call the user registration endpoint and get a random user identifier managed by the server. The user registration feature can be disabled from the specific configuration and the user id can be directly injected to the tracker that will use this user id for the upload apis payload.

If the `overrideFirstInstall` parameter is true, the tracker will consider the current timestamp as the new starting point to retrieve the activities data.

```swift
TrackerManager.instance.saveUserRegistrationId("", overrideFirstInstall: true)
```

### Target app

This value can be set from a predefined enum to let the tracker know which application is currently using the tracker

```swift
TrackerManager.instance.setTargetApp(.MOVING_HEALTH)
```

### Upload data url

The base url where the tracker will send the data can be overridden into the *Info.plist* file of the host application project

```xml
<key>TrackerBaseUrl</key>
<string>https://www.example.com</string>
```

### Initialisation

This must be called from the host application to initialise the tracker

```swift
TrackerManager.initialize(launchOptions: launchOptions)
```

### Capabilities

The host application must have the *Location updates* and the *Background fetch* capabilities enabled, so the Info.plist file must then automatically include these background modes

```xml
<key>UIBackgroundModes</key>
<array>
  <string>fetch</string>
  <string>location</string>
</array>
```

The host application must include the explanation strings references for each required permission, to correctly access the device location and the motion activities

```xml
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>NSLocationAlwaysAndWhenInUseUsageDescription</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>NSLocationAlwaysUsageDescription</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>NSLocationWhenInUseUsageDescription</string>
<key>NSMotionUsageDescription</key>
<string>NSMotionUsageDescription</string>
```

These strings must be defined into localized *InfoPlist.strings* files, this is an example

```
"NSLocationWhenInUseUsageDescription" = "The location access is needed to manage the geolocation correctly";
"NSLocationAlwaysUsageDescription" = "The location access is needed to manage the geolocation correctly in background";
"NSLocationAlwaysAndWhenInUseUsageDescription" = "The location access is needed to manage the geolocation correctly also when the app is not in use";
"NSMotionUsageDescription" = "The motion and fitness data access is needed to correctly identify the daily activity";
```

## Usage

### Start and Stop

These apis can be called from the host application to start or stop the tracker

```swift
TrackerManager.instance.startLocationTracking()
TrackerManager.instance.stopLocationTracking()
```

### Data Retrieve

There are multiple tables to query the database, this is an example to retrieve the segments between two dates

```swift
let fromDate = Date().addingTimeInterval(-3600)
let toDate = Date()
let segments = TrackerTableSegments.getBetween(fromDate, toDate)
```

### Data Refresh

Even if the tracker data are always available it's better to manually refresh the data when needed. For example when the application starts or the selected range of dates changes. The refresh method provides an asynchronous callback to be notified when the data refresh is completed.

```swift
let fromDate = Date().addingTimeInterval(-3600)
let toDate = Date()
TrackerManager.instance.refresh(fromDate, toDate, {
    // add your code here
})
```

### Integration test

This code can be executed during the debug to know if the tracker integration succeed

```swift
#if DEBUG
TrackerUtils.testTrackerIntegration({ success, error in
    if !success {
        print("Tracker integration failed")
    }
})
#endif
```

## Known Issues

The tracker can be deployed for emulators or from phisycal device, but not for both at the same time.

## License

Library is available under the Apache 2.0 license. See the [LICENSE](./LICENSE) file for more info.

## Copyright

© Active Orbit, 2023
