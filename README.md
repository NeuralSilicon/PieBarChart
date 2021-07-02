# PieBarChart
CocoPod library written in Swift

## Introduction

`PieBarChart` is a pie and bar chart that includes selections and animations.

![Bar](https://user-images.githubusercontent.com/35051980/124334144-d19a7680-db5b-11eb-9004-960f80982f2f.gif)


## Installation

### Cocoapods

[Cocoapods](https://cocoapods.org/#install) is a dependency manager for Swift and Objective-C Cocoa projects. To use PieBarChart with CocoaPods, add it in your `Podfile`.

```ruby
pod 'PieBarChart'
```

## Usage

import `PieBarChart`.

```swift
import PieBarChart
```

### Initialization

By coding, create a var of type `PieBarChart` and initialize it

or  by storyboard, changing class of any `UIView` to `PieBarChart`.

Then, you are going to need to add values to ChartData, it's a struct with name, data, and color.


```swift
PieBarChart().addChart(chart: .Pie, data: chartData, orientation: orientation)
```

orientation is only for Pie Chart and comes with default vertical value.


## License

The MIT License (MIT)

Copyright (c) 2021 Ian Cooper [@neuralsilicon](https://twitter.com/neuralsilicon)
