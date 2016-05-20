# Digita11y iOS

Native iOS client for Roundware built for PEM, Smithsonian, and BMA using the RWFramework.

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

We are using [Crashlytics](https://fabric.io) and [Fastlane](https://github.com/fastlane/fastlane) for workflow.  We use RubyGems so install our gems listed in the Gemfile with Bundler.  We advise using rbenv.

You will need to populate a dotenv file to deploy to Crashlytics in `fastlane/.env`.  There's an example file to follow as well.

``` shell
$ bundle install
$ bundle exec fastlane crashlytics

```

When you want to add a new device or team member to a distribution, invite them to the team and project in Beta (Crashlytics) and then add their device and name to the `devices.txt` file (untracked).  Then run `bundle exec fastlane devices` and then the crashlytics command.

##License

TBD

##Authors

Christopher Reed, [@seereadnow](http://twitter.com/seereadnow)
