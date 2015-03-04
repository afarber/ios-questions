#NZCircularImageView ![License MIT](https://go-shields.herokuapp.com/license-MIT-blue.png)

<p align="center">
  <img src="http://s23.postimg.org/8wnsherxn/image.gif" alt="NZCircularImageView" title="NZCircularImageView" width="260" height="260">
</p>

NZCircularImageView is a UIImageView extension. Its performs async download image and leaves with rounded edge.

It can be used, for example, to presenting pictures of user profiles.

[![Build Status](https://api.travis-ci.org/NZN/NZCircularImageView.png)](https://api.travis-ci.org/NZN/NZCircularImageView.png)
[![Cocoapods](https://cocoapod-badges.herokuapp.com/v/NZCircularImageView/badge.png)](http://beta.cocoapods.org/?q=name%3Anzcircularimageview%2A)
[![Cocoapods](https://cocoapod-badges.herokuapp.com/p/NZCircularImageView/badge.png)](http://beta.cocoapods.org/?q=name%3Anzcircularimageview%2A)
[![Analytics](https://ga-beacon.appspot.com/UA-48753665-1/NZN/NZCircularImageView/README.md)](https://github.com/igrigorik/ga-beacon)

## Requirements

NZCircularImageView works on iOS 6.0+ version and is compatible with ARC projects. It depends on the following Apple frameworks, which should already be included with most Xcode templates:

* Foundation.framework
* QuartzCore.framework
* UIKit.framework

You will need LLVM 3.0 or later in order to build NZCircularImageView.

NZCircularImageView uses [SDWebImage](https://github.com/rs/SDWebImage) and [UIActivityIndicator-for-SDWebImage](https://github.com/JJSaccolo/UIActivityIndicator-for-SDWebImage) to download async images.

## Adding NZCircularImageView to your project

### Cocoapods

[CocoaPods](http://cocoapods.org) is the recommended way to add NZCircularImageView to your project.

* Add a pod entry for NZCircularImageView to your Podfile `pod 'NZCircularImageView'`
* Install the pod(s) by running `pod install`.

### Source files

Alternatively you can directly add source files to your project.

1. Download the [latest code version](https://github.com/NZN/NZCircularImageView/archive/master.zip) or add the repository as a git submodule to your git-tracked project.
2. Open your project in Xcode, then drag and drop all files at `NZCircularImageView` folder onto your project (use the "Product Navigator view"). Make sure to select Copy items when asked if you extracted the code archive outside of your project.
3. Install [SDWebImage](https://github.com/rs/SDWebImage)
4. Install [UIActivityIndicator-for-SDWebImage](https://github.com/JJSaccolo/UIActivityIndicator-for-SDWebImage)

## Usage

The class overrides `-(void)setFrame:`, thus ensuring that every time an image is set, it will be presented in a rounded shape.
This class also uses `UIViewContentModeScaleAspectFill` contentMode with the `clipsToBounds` flag so that the image resolution is not changed.

* Setting at Storyboard to automatic rounded image

<p align="center">
  <img src="http://s28.postimg.org/dkc2r8tgd/NZCircular_Image_View.jpg" alt="NZCircularImageView" title="NZCircularImageView" width="500" height="350">
</p>

* Setting a rounded avatar image

```objective-c
circularImageView.image = [UIImage imageNamed:@"Default-Avatar"];
```

* Async download image

```objective-c
// this method append parameters at url:
// - width: image view width
// - height: image view height
// - mode: crop (crop image from center)
[circularImageView setImageWithResizeURL:@"http://example.com/image.png"];
//
// ... with custom loading indicator
[circularImageView setImageWithResizeURL:kImageUrl
             usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//
// ... with completion block
[circularImageView setImageWithResizeURL:kImageUrl
             usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                    NSLog(@"Download completed");
              }];
```

To enable the logs in debug/release mode, add `#define NZDEBUG` at `*-Prefix.pch` file in your project.

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).

## Change-log

A brief summary of each NZCircularImageView release can be found on the [wiki](https://github.com/NZN/NZCircularImageView/wiki/Change-log).

## To-do Items
