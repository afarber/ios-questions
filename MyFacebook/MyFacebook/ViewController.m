#import "ViewController.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

#define FB_APP_ID @"432298283565593"
//#define FB_APP_ID @"262571703638"

@interface ViewController ()
@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccount *facebookAccount;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Facebook is available: %d", [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]);
    
    [self getMyDetails];
}

- (void) getMyDetails {
    if (!_accountStore) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    
    ACAccountType *facebookAccountType = [_accountStore
                                        accountTypeWithAccountTypeIdentifier: ACAccountTypeIdentifierFacebook];
    NSDictionary *options = @{
                              ACFacebookAppIdKey: FB_APP_ID,
                              ACFacebookPermissionsKey: @[@"basic_info"]};
    
    [_accountStore requestAccessToAccountsWithType:facebookAccountType
                                           options:options
                                        completion:^(BOOL granted, NSError *error)
    {
        if (granted) {
            NSLog(@"Basic access granted");
        } else {
            NSLog(@"Basic access denied %@", error);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
