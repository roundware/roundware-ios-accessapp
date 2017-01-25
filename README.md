# Digita11y iOS

Native iOS client for Roundware built for PEM, Smithsonian, and BMA using the RWFramework.

## Links
- [Digita11y Project Site](https://www.digita11y.org/)
- [Digita11y: Development](https://github.com/seeRead/roundware-ios-digita11y)
- [Digita11y: App](https://github.com/roundware/roundware-ios-digita11y)
- [RWFramework:Development](https://github.com/seeRead/roundware-ios-framework-v2)
- [RWFramework](https://github.com/roundware/roundware-ios-framework-v2)
- [Slack](https://roundware.slack.com/messages/digita11y-ios/)

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

## Hierarchy

`Project -> Exhibition -> Room -> Item`

Exhibition, Room, and Item are UIGroups, each with a set of UIItems filtered by the selected parent UIItem and each UIItems having a corresponding Tag.

## License

TBD

## Authors

Christopher Reed, [@seereadnow](http://twitter.com/seereadnow)
