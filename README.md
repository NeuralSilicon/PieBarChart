
# PieBarChart
CocoaPod library written in Swift 5 with UIKit for iOS 13+.

## Introduction

`PieBarChart` is a pie and bar chart that includes selections and animations.


![Bar](https://user-images.githubusercontent.com/35051980/124334912-2b9c3b80-db5e-11eb-889b-307414d92e70.gif)![Pie](https://user-images.githubusercontent.com/35051980/124334809-e841cd00-db5d-11eb-8d44-e2664a4b2419.gif)![PieBar](https://user-images.githubusercontent.com/35051980/124334885-1a532f00-db5e-11eb-8b4f-0b33c5736261.gif)![BarDark](https://user-images.githubusercontent.com/35051980/124335056-9ea5b200-db5e-11eb-8897-816ee2580ee7.gif)![PieDark](https://user-images.githubusercontent.com/35051980/124335099-c39a2500-db5e-11eb-8599-e6e050a205a6.gif)![PieBarDark](https://user-images.githubusercontent.com/35051980/124335124-df9dc680-db5e-11eb-8ee8-dd3154d1a793.gif)


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
