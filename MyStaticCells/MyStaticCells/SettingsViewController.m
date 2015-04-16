//
//  SettingsViewController.m
//  MyStaticCells
//
//  Created by afarber on 16/04/15.
//  Copyright (c) 2015 afarber.de. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (nonatomic, assign) BOOL soundOn;
@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refreshView];
    
    self.labelTitle.text = @"Settings";
    self.labelButtonSounds.text = @"Sounds";
    self.labelButtonRestore.text = @"Restore Purchases";
    self.labelButtonEmail.text = @"Email Support";
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        self.labelTitle.font = [UIFont fontWithName:@"Lucida Calligraphy" size:50];
        self.labelButtonSounds.font = [UIFont fontWithName:@"Segoe UI" size:30];
        self.labelButtonEmail.font = [UIFont fontWithName:@"Segoe UI" size:30];
        self.labelButtonRestore.font = [UIFont fontWithName:@"Segoe UI" size:30];
        self.labelButtonSoundsOnOff.font = [UIFont fontWithName:@"Segoe UI" size:30];
    }
    else
    {
        self.labelTitle.font = [UIFont fontWithName:@"Lucida Calligraphy" size:25];
        self.labelButtonSounds.font = [UIFont fontWithName:@"Segoe UI" size:20];
        self.labelButtonEmail.font = [UIFont fontWithName:@"Segoe UI" size:20];
        self.labelButtonRestore.font = [UIFont fontWithName:@"Segoe UI" size:20];
        self.labelButtonSoundsOnOff.font = [UIFont fontWithName:@"Segoe UI" size:20];
    }
    
    self.view.backgroundColor = THEME_COLOR_GRAY;
    self.labelTitle.textColor = THEME_COLOR_BLUE;
    self.labelButtonSounds.textColor = THEME_COLOR_GRAY_TEXT;
    self.labelButtonEmail.textColor = THEME_COLOR_GRAY_TEXT;
    self.labelButtonRestore.textColor = THEME_COLOR_GRAY_TEXT;
 }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshView
{
    if (self.soundOn)
    {
        self.labelButtonSoundsOnOff.text = @"On";
        self.labelButtonSoundsOnOff.textColor = THEME_COLOR_BLUE;
    }
    else
    {
        self.labelButtonSoundsOnOff.text = @"Off";
        self.labelButtonSoundsOnOff.textColor = THEME_COLOR_GRAY_TEXT;
    }
    
    NSLog(@"refreshView: %d", self.soundOn);
}

- (void)clickedSupport
{
    NSLog(@"clickedSupport");

    // The MFMailComposeViewController class is only available in iPhone OS 3.0 or later.
	// So, we must verify the existence of the above class and provide a workaround for devices running
	// earlier versions of the iPhone OS.
	// We display an email composition interface if MFMailComposeViewController exists and the device
	// can send emails.	Display feedback message, otherwise.
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
	if (mailClass != nil) {
        //[self displayMailComposerSheet];
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail]) {
			[self displayMailComposerSheet];
		}
		else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Email error" message:@"This device is not configured to send emails." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [self.view addSubview:alert];
            [alert show];
		}
	}
	else	{
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Email error" message:@"This device is not configured to send emails." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self.view addSubview:alert];
        [alert show];
	}
}

- (void)clickedRestore
{
    NSLog(@"clickedRestore");
}

- (void)clickedSound
{
    NSLog(@"clickedSound");
    self.soundOn = !self.soundOn;
    [self refreshView];
}

- (IBAction)clickedClose:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Compose Mail/SMS

// Displays an email composition interface inside the application. Populates all the Mail fields.
-(void)displayMailComposerSheet
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@"Alexander.Farber@gmail.com"];
	
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    UIDevice *currentDevice = [UIDevice currentDevice];
    NSString *model = [currentDevice model];
    NSString *systemVersion = [currentDevice systemVersion];
    NSArray *languageArray = [NSLocale preferredLanguages];
    NSString *language = [languageArray objectAtIndex:0];
    NSLocale *locale = [NSLocale currentLocale];
    NSString *country = [locale localeIdentifier];
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    NSString *emailBody = [NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\nApp Name: %@ \nModel: %@ \nSystem Version: %@ \nLanguage: %@ \nCountry: %@ \nApp Version: %@", appName, model, systemVersion, language, country, appVersion];
    
	[picker setToRecipients:toRecipients];
    [picker setMessageBody:emailBody isHTML:NO];
	
	[self presentViewController:picker
                       animated:YES
                     completion:^{
                     }];
}

#pragma mark -
#pragma mark Dismiss Mail/SMS view controller

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the
// message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    if (result == MFMailComposeResultFailed) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Email error"
                                                            message:@"There was an error sending your message. Please try again later!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
	}
    
	[self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark -
#pragma mark Table View delegate
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *clickedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (clickedCell == self.cellSounds)
        [self clickedSound];
    else if (clickedCell == self.cellSupport)
        [self clickedSupport];
    else if (clickedCell == self.cellRestore)
        [self clickedRestore];
}

@end
