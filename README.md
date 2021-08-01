# responsive_util
[![pub package](https://img.shields.io/pub/v/responsive_util.svg)](https://pub.dartlang.org/packages/responsive_util)
[![Platform](https://img.shields.io/badge/platform-android%20|%20ios-green.svg)](https://pub.dartlang.org/packages/responsive_util)

A Flutter widget that allows drag resizing of its child's bounds to easily test responsive design.

<p>
  <img width="205px" alt="Example" src="https://raw.githubusercontent.com/hawkinsjb1/responsive_util/master/assets/example.gif"/>
  <img width="205px" alt="Example" src="https://raw.githubusercontent.com/hawkinsjb1/responsive_util/master/assets/example2.gif"/>
</p>


<br>

## Usage
Wrap a widget such as a `Scaffold` with a `ResponsiveUtil` and resize it by dragging from the bottom right.

Double-tap to reset bounds.

<br>

|  Properties  |   Description   |
|--------------|-----------------|
| `child` | The Widget to resize |
|`builder`| An alternative structure to be used in place of `child` which directly provides updated constraints to layout similar to a `LayoutBuilder`  |
| `disabled` | If `True`, bypasses all functionality |
| `scrollController` | Required for Widgets that exist in some ScrollView |
