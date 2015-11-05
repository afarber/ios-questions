//
//  ViewController.h
//  QRCodeReader
//
//  Created by Alexander Farber on 04.11.15.
//  Copyright © 2015 Gabriel Theodoropoulos. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;
@import CoreBluetooth;

@interface ViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate, CBCentralManagerDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbitemStart;

- (IBAction)startStopReading:(id)sender;

@end

