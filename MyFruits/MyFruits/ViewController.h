//
//  ViewController.h
//  MyFruits
//
//  Created by afarber on 06/05/15.
//  Copyright (c) 2015 afarber.de. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *myButton;
@property (weak, nonatomic) IBOutlet UIImageView *myImage;

- (IBAction)myButtonClicked:(id)sender;

@end

