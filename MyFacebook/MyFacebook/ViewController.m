#import "ViewController.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *facebookAccountType = [accountStore accountTypeWithAccountTypeIdentifier: ACAccountTypeIdentifierFacebook];
    
    NSDictionary *options = @{
                              ACFacebookAudienceKey : ACFacebookAudienceEveryone,
                              ACFacebookAppIdKey : @"432298283565593",
                              ACFacebookPermissionsKey : @[@"id",
                                                           @"first_name",
                                                           @"gender",
                                                           @"location"]};
    
    [accountStore requestAccessToAccountsWithType:facebookAccountType options:options completion:^(BOOL granted, NSError *error)
    {
        if (granted)
        {
            NSLog(@"Basic access granted");
        }
        else
        {
            NSLog(@"Basic access denied %@", error);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
