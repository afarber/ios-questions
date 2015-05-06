//
//  ViewController.m
//  MyFruits
//
//  Created by afarber on 06/05/15.
//  Copyright (c) 2015 afarber.de. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)myButtonClicked:(id)sender {
    static int i = 0;
    
    NSString* name = [NSString stringWithFormat:@"fruit%d.png", (i++ % 5 + 1)];
    UIImage* image = [UIImage imageNamed:name];
    
    [self.myImage setImage:image];
    [self.myButton setTitle:name forState:UIControlStateNormal];
}

@end
