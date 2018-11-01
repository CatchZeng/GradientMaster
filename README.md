# GradientMaster

[![Version](https://img.shields.io/cocoapods/v/GradientMaster.svg?style=flat)](https://cocoapods.org/pods/GradientMaster)
[![License](https://img.shields.io/cocoapods/l/GradientMaster.svg?style=flat)](https://cocoapods.org/pods/GradientMaster)
[![Platform](https://img.shields.io/cocoapods/p/GradientMaster.svg?style=flat)](https://cocoapods.org/pods/GradientMaster)

A IBDesignable UIView class with a gradient rendered and customizable in the storyboard (effect, direction,...) and support gradient animation.

## Usage

### IBDesignable

![](https://github.com/CatchZeng/GradientMaster/blob/master/IBDesignable.gif?raw=true)

* Set the class to GradientMasterView.
* Customizable direction and effect you like.
* Run it.


### Animation

![](https://github.com/CatchZeng/GradientMaster/blob/master/animation.gif?raw=true) ![](https://github.com/CatchZeng/GradientMaster/blob/master/animation2.gif?raw=true)

#### Set animation duration.

```
gradientView.animationDuration = 5.0
```

#### Start animation.

```
gradientView.startAnimation()
```

#### Stop animation.

```
gradientView.stopAnimation()
```



## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

GradientMaster is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'GradientMaster'
```

## Author

catchzeng, 891793848@qq.com

## License

GradientMaster is available under the MIT license. See the LICENSE file for more info.
