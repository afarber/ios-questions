//
//  ViewController.h
//  QRCodeReader
//
//  Created by Alexander Farber on 04.11.15.
//  Copyright © 2015 Gabriel Theodoropoulos. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;

@interface ViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbitemStart;

- (IBAction)startStopReading:(id)sender;

@end

