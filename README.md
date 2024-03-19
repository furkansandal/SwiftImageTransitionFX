# SwiftImageTransitionFX

SwiftImageTransitionFX is a Swift-based library designed for iOS, enabling developers to easily add captivating before-and-after image transitions to their applications. With customizable transition effects, you can enhance the visual experience in your app.

![](video.gif)

## Features

- **Customizable Transitions:** Easily adjust the color, width, and speed of the image transition effect.
- **Looping Animations:** Option to loop the transition effect infinitely or for a set number of times.
- **Auto Reverse:** Automatically return to the before image after showing the after image, with customizable speeds.

## Requirements

- iOS 12.0+
- Xcode 11+
- Swift 5.5+

## Installation

You can integrate SwiftImageTransitionFX into your project manually or SPM

### SPM Link
```swift
https://github.com/furkansandal/SwiftImageTransitionFX.git
```

### Manual Installation

1. Download the `SwiftImageTransitionFX.swift` file.
2. Drag and drop it into your Xcode project.
3. Ensure to check "Copy items if needed" and add it to your target.

## Usage

### Basic Setup

1. Import SwiftImageTransitionFX in your ViewController.

```swift
import SwiftImageTransitionFX
```

2. Initialize `SwiftImageTransitionFXView` and add it to your view.

```swift
let imageTransitionView = SwiftImageTransitionFXView()
view.addSubview(imageTransitionView)
```

3. Set the before and after images.

```swift
imageTransitionView.populate(beforeImage: UIImage(named: "beforeImage"), afterImage: UIImage(named: "afterImage"))
```

4. Start the transition.

```swift
imageTransitionView.start()
```

### Customization

Customize the transition by adjusting the properties of your `SwiftImageTransitionFXView` instance.

```swift
imageTransitionView.transitionColor = .red
imageTransitionView.transitionWidth = 10.0
imageTransitionView.forwardSpeed = 5.0
imageTransitionView.backwardSpeed = 5.0
imageTransitionView.isInfinityLoop = false
```

## Contribution

Contributions are very welcome! If you'd like to contribute, please fork the repository and use a feature branch. Pull requests are warmly welcome.

## Licensing

The code in this project is licensed under MIT license. See the LICENSE file for more information.
