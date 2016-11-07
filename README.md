## Noonian

A tool for building Android apps. Inspired by [a man who had some success in
building androids](http://memory-alpha.wikia.com/wiki/Noonian_Soong).

[![Build Status](https://travis-ci.org/scottrhoyt/Noonian.svg?branch=master)](https://travis-ci.org/scottrhoyt/Noonian)
[![codecov](https://codecov.io/gh/scottrhoyt/Noonian/branch/master/graph/badge.svg)](https://codecov.io/gh/scottrhoyt/Noonian)
![Swift](https://img.shields.io/badge/Swift-3.0-orange.svg)
![SPM](https://img.shields.io/badge/SPM-Compatible-green.svg)

--------------

### Installation

* [Download the latest release](https://github.com/scottrhoyt/Noonian/releases)
* Swift 3+ is installed
  * OSX: Included in Xcode 8+
  * Linux: available at [Swift](http://www.swift.org) (`make linux_swift` will
    create a local installation of Swift in the source directory)
* Run `make install`

### Android SDK Requirements

* Java 7+ installed and set in `$JAVA_HOME`
* `$ANDROID_HOME` is set to an Android SDK directory
* The target and build_tools that you intend to use have been downloaded
* Your build tools contain the jack build chain and your source is compatible
* You have a valid Android debug key located at `~/.android/debug.keystore`
* To install your app, you must have a simulator running

### Usage

Use `noonian help` and `noonian help <action>` to display command line help.

`init` can be run from any directory, but all other commands must be run from
your project directory.

#### Initialize A Project

`noonian init <Project Name>`

**Options**

* `--path <path for project`
* `--package <package name>`
* `--target <android api target>`
* `--activity <name of activity to create>`

#### Build Your Project

`noonian build`

#### Package, Sign, Zipalign APK

`noonian package`

#### Install On Active simulator

`noonian install`

### Configuration

Noonian is configured via a `.noonian.yml` file. `noonian init` will create a
basic configuration file for you with the minimum necessary settings, but you
can modify it to further suit your needs.

#### Project Settings

* `app_name: <app name>` specifies the name of your app for packaging and
  installation purposes.
* `target: <target name>` specified which APIs to build against and package.
* `build_tools: <tools version>` specifies which version of the SDK build tools
  to use.

#### Before/After

All actions other than `init` can be configured with shell commands to run
before and after the action by using the `before_<action>` and `after_<action>`
keys. The value can either be a single command or an array of commands.

#### Example Configuration

```yaml
## You can use comments to annotate your configuration
app_name: AndroidApp
target: android-25
build_tools: 25.0.0

## Build
before_build: echo running a command
after_build:
  - echo running command 1
  - echo running command 2

## Package
after_install:
  - echo we finished!
```
