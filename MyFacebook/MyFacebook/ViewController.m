#import "ViewController.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

#define FB_APP_ID @"432298283565593"
//#define FB_APP_ID @"262571703638"

@interface ViewController ()
@property (strong, nonatomic) ACAccount *facebookAccount;
@property (strong, nonatomic) ACAccountType *facebookAccountType;
@property (strong, nonatomic) ACAccountStore *accountStore;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (NO == [SLComposeViewController isAvailableForServiceType: SLServiceTypeFacebook]) {
        [self showAlert:@"There are no Facebook accounts configured. Please add or create a Facebook account in Settings."];
        return;
    }
    
    [self getMyDetails];
}

- (void) getMyDetails {
    if (! _accountStore) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    
    if (! _facebookAccountType) {
        _facebookAccountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    }
    
    NSDictionary *options = @{ ACFacebookAppIdKey: FB_APP_ID };
    
    [_accountStore requestAccessToAccountsWithType: _facebookAccountType
                                           options: options
                                        completion: ^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [_accountStore accountsWithAccountType:_facebookAccountType];
            _facebookAccount = [accounts lastObject];
            
            NSURL *url = [NSURL URLWithString:@"https://graph.facebook.com/me"];
            
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                    requestMethod:SLRequestMethodGET
                                                              URL:url
                                                       parameters:nil];
            request.account = _facebookAccount;
            
            [request performRequestWithHandler:^(NSData *responseData,
                                                 NSHTTPURLResponse *urlResponse,
                                                 NSError *error) {
                
                NSDictionary *responseDictionary = [NSJSONSerialization
                                                    JSONObjectWithData:responseData
                                                    options:0
                                                    error:nil];
                //NSLog(@"%@", responseDictionary);
                NSLog(@"id: %@", responseDictionary[@"id"]);
                NSLog(@"first_name: %@", responseDictionary[@"first_name"]);
                NSLog(@"last_name: %@", responseDictionary[@"last_name"]);
                NSLog(@"gender: %@", responseDictionary[@"gender"]);
                NSLog(@"city: %@", responseDictionary[@"location"][@"name"]);
            }];
        } else {
            [self showAlert:@"Facebook access for this app has been denied. Please edit Facebook permissions in Settings."];
        }
    }];
}

- (void) showAlert:(NSString*) msg {
    assert([NSThread isMainThread]);
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"WARNING"
                                  message:msg
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    });
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
