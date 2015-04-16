//
//  SettingsViewController.h
//  MyStaticCells
//
//  Created by afarber on 16/04/15.
//  Copyright (c) 2015 afarber.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

//  theme colors
#define     THEME_COLOR_RED             [UIColor colorWithRed:255.0/255 green:143.0/255 blue:143.0/255 alpha:1.0]
#define     THEME_COLOR_GRAY            [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1.0]
#define     THEME_COLOR_GRAY_BACKGROUND [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0]
#define     THEME_COLOR_GRAY_TEXT       [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0]
#define     THEME_COLOR_GRAY_LIGHT      [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0]
#define     THEME_COLOR_BLUE            [UIColor colorWithRed:19.0/255 green:175.0/255 blue:207.0/255 alpha:1.0]

@interface SettingsViewController : UITableViewController <MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *labelTitle;

@property (nonatomic, weak) IBOutlet UILabel *labelButtonSounds;
@property (nonatomic, weak) IBOutlet UILabel *labelButtonEmail;
@property (nonatomic, weak) IBOutlet UILabel *labelButtonRestore;
@property (nonatomic, weak) IBOutlet UILabel *labelButtonSoundsOnOff;

@property (weak, nonatomic) IBOutlet UITableViewCell *cellSounds;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellSupport;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellRestore;

- (IBAction)clickedClose:(id)sender;

@end
