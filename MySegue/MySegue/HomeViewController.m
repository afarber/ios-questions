//
//  ViewController.m
//  MySegue
//
//  Created by Alexander Farber on 21.03.15.
//  Copyright (c) 2015 Alexander Farber. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"HomeViewController viewDidLoad");
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"HomeViewController prepareForSegue");
}

- (IBAction) unwindToHome:(UIStoryboardSegue *)segue {
    NSLog(@"HomeViewController prepareForUnwind");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
