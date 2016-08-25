# TYUpdatePrompt

Remind the user to update the application when a new version is available.

[![CI Status](http://img.shields.io/travis/luckytianyiyan/TYUpdatePrompt.svg?style=flat)](https://travis-ci.org/luckytianyiyan/TYUpdatePrompt)
[![Version](https://img.shields.io/cocoapods/v/TYUpdatePrompt.svg?style=flat)](http://cocoapods.org/pods/TYUpdatePrompt)
[![License](https://img.shields.io/cocoapods/l/TYUpdatePrompt.svg?style=flat)](http://cocoapods.org/pods/TYUpdatePrompt)
[![Platform](https://img.shields.io/cocoapods/p/TYUpdatePrompt.svg?style=flat)](http://cocoapods.org/pods/TYUpdatePrompt)

## Usage
<details open=1>
<summary>Check Version</summary>

```
TYUpdatePrompt *updatePrompt = [TYUpdatePrompt sharedInstance];
[updatePrompt checkVersionWithCompletionHandler:^(BOOL isNeedUpdate, NSString *appName, TYUPAppStoreInfo *appStoreInfo) {
    if (isNeedUpdate) {
        NSString *title = @"Update Available";
        NSString *message = [NSString stringWithFormat:@"A new version of %@ is available. Please update to version %@ now.\n\nRelease Notes\n\n%@",
                             appName,
                             appStoreInfo.version,
                             appStoreInfo.releaseNotes];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Update", @"Next time", nil];
        [alertView show];
    }
}];
```
</details>

<details>
<summary>Check Version Daily</summary>

```
TYUpdatePrompt *updatePrompt = [TYUpdatePrompt sharedInstance];
[updatePrompt checkVersionDailyWithCompletionHandler:^(BOOL isNeedUpdate, NSString *appName, TYUPAppStoreInfo *appStoreInfo) {
    ...
}];
```
</details>

<details>
<summary>Check Version Weekly</summary>

```
TYUpdatePrompt *updatePrompt = [TYUpdatePrompt sharedInstance];
[updatePrompt checkVersionWeeklyWithCompletionHandler:^(BOOL isNeedUpdate, NSString *appName, TYUPAppStoreInfo *appStoreInfo) {
    ...
}];
```
</details>

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

TYUpdatePrompt is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TYUpdatePrompt"
```

## License

TYUpdatePrompt is available under the MIT license. See the LICENSE file for more info.
