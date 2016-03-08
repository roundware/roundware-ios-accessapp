# Digita11y iOS

Native iOS client for Roundware built for PEM, Smithsonian, and BMA.

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

``` shell
$ bundle install

```

You will need to populate a dotenv file to deploy to Crashlytics in `fastlane/.env`.  There's an example file to follow as well.

##License

TBD

##Authors

Christopher Reed, [@seereadnow](http://twitter.com/seereadnow)
