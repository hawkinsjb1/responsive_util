# responsive_util
[![pub package](https://img.shields.io/pub/v/responsive_util.svg)](https://pub.dartlang.org/packages/responsive_util)
[![Platform](https://img.shields.io/badge/platform-android%20|%20ios-green.svg)](https://pub.dartlang.org/packages/responsive_util)

A wrapper that provides draggable manipulation of a widget's size to test it's responsive design.

<p>
  <img width="205px" alt="Example" src="https://raw.githubusercontent.com/hawkinsjb1/responsive_util/master/assets/example.gif"/>
  <img width="205px" alt="Example" src="https://raw.githubusercontent.com/hawkinsjb1/responsive_util/master/assets/example2.gif"/>
</p>


<br>

## Usage
Wrap a widget such as a `Scaffold` with a `ResponsiveUtil` and resize it by dragging from the bottom right.

<br>

|  Properties  |   Description   |
|--------------|-----------------|
| `child` | The Widget to resize |
|`onResize`| For conditional layouts that rely on `MediaQuery` rather than `LayoutBuilder` to determine available space, use `onResize` to obtain a virtual screen `Size`.  |
| `disabled` | If `True`, bypasses all functionality |
| `scrollController` | Required for Widgets that exist in some ScrollView |