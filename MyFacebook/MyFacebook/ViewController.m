#import "ViewController.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface ViewController ()
@property (strong, nonatomic) ACAccountStore *accountStore;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *facebookAccountType = [_accountStore
                                        accountTypeWithAccountTypeIdentifier: ACAccountTypeIdentifierFacebook];
    NSDictionary *options = @{
                              //ACFacebookAppIdKey : @"262571703638",
                              ACFacebookAppIdKey : @"432298283565593",
                              ACFacebookPermissionsKey : @[@"id",
                                                           @"first_name",
                                                           @"gender",
                                                           @"location"]};
    
    [_accountStore requestAccessToAccountsWithType:facebookAccountType
                                           options:options
                                        completion:^(BOOL granted, NSError *error)
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
}

@end
