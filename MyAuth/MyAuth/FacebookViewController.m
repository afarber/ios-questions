#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "FacebookViewController.h"

static NSString* const kAppId =  @"432298283565593";
static NSString* const kAvatar = @"http://graph.facebook.com/%@/picture?type=large";
static NSString* const kMe =     @"https://graph.facebook.com/me";

@interface FacebookViewController () {
    ACAccount* _facebookAccount;
    ACAccountType* _facebookAccountType;
    ACAccountStore* _accountStore;
}
@end

@implementation FacebookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self fetchFacebookUser];
}

-(void)fetchFacebookUser
{
    if (!_accountStore) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    
    if (!_facebookAccountType) {
        _facebookAccountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    }
    
    NSDictionary *options = @{ ACFacebookAppIdKey: kAppId };
    
    [_accountStore requestAccessToAccountsWithType: _facebookAccountType
                                           options: options
                                        completion: ^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [_accountStore accountsWithAccountType:_facebookAccountType];
            _facebookAccount = [accounts lastObject];
            
            NSURL *url = [NSURL URLWithString:kMe];
            
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

-(void)showAlert:(NSString*)msg
{
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
