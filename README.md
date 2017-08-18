# Access App iOS

Native iOS client for Roundware built for PEM, Smithsonian, and BMA using the RWFramework.

## Links
- [Access App Project Site](https://www.theaccessapp.org/)
- [Access App: App](https://github.com/roundware/roundware-ios-accessapp)
- [RWFramework](https://github.com/roundware/roundware-ios-framework-v2)
- [Slack](https://roundware.slack.com/messages/accessapp-ios/)

## Build

Install [Cocoapods](http://cocoapods.org).

``` shell
$ gem install cocoapods
```

Install the podfiles and then open the workspace.

``` shell
$ pod install
$ open Digita11y.xcworkspace 
```

## Deploy

We are using [Fabric/Crashlytics](https://fabric.io) to manage beta deploys and the command line tool [Fastlane](https://github.com/fastlane/fastlane) to accelerate the testing workflow.  We use RubyGems so install the ruby dependencies listed in the Gemfile with Bundler.  We advise using rbenv to manage your ruby runtime version.

You will need to populate a dotenv file to deploy to Crashlytics in `fastlane/.env`.  There's an example file to follow as well.

``` shell
$ bundle install
$ bundle exec fastlane crashlytics

```

When you want to add a new device or team member to a distribution, invite them to the team and project in Beta (Crashlytics) and then add their device and name to the `devices.txt` file (untracked).  Then run `bundle exec fastlane devices` and then the crashlytics command.

## Release

Untested, but this should work given a correctly setup [Appfile](https://github.com/roundware/roundware-ios-accessapp/blob/master/fastlane/Appfile), [Deliverfile](https://github.com/roundware/roundware-ios-accessapp/blob/master/fastlane/Deliverfile), [Matchfile](https://github.com/roundware/roundware-ios-accessapp/blob/master/fastlane/Matchfile), and certificates (see [codesigning.guide](https://codesigning.guide/)).

```
bundle exec fastlane ios appstore
```


## Data Model

For Access App

`Project -> Exhibition -> Room -> Object`

For RWFramework (via roundware server)

`UIGroup -> UIItems -> Tag -> Assets`

Projects are set in the `plist` while Exhibitions, Rooms, and Items are each UIGroups, each with a set of UIItems filtered by the selected parent UIItem.  UIItems each refer to tag and tags refer to assets.

Be aware that iOS has it's own concept of tag (e.g. button.tag) and uses `UI` as a prefix (e.g. UIView).

## License

TBD

## Authors

Christopher Reed, [@seereadnow](http://twitter.com/seereadnow)
