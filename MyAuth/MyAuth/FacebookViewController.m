#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "FacebookViewController.h"
#import "SocialNetwork.h"

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

    [self fetchUser];
}

-(void)fetchUser
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
            
            [request performRequestWithHandler:^(NSData *data,
                                                 NSHTTPURLResponse *resp,
                                                 NSError *error) {
                if (error == nil && [data length] > 0) {
                    id json = [NSJSONSerialization JSONObjectWithData:data
                                                              options:NSJSONReadingMutableContainers
                                                                error:nil];
                    //NSLog(@"json = %@", json);
                    
                    User *user = [self createUserFromJson:json];
                    [user save];
                    
                    double delayInSeconds = 1;
                    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
                        [self performSegueWithIdentifier: @"replaceFacebook" sender: self];
                    });
                }
            }];
        } else {
            [self showAlert:@"Facebook access for this app has been denied. Please edit Facebook permissions in Settings."];
        }
    }];
}

- (User*)createUserFromJson:(id)json
{
    if (![json isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Parsing response failed");
        return nil;
    }
    
    NSDictionary *dict = json;
    
    User *user = [[User alloc] init];
    user.key       = kFB;
    user.userId    = dict[@"id"];
    user.firstName = dict[@"first_name"];
    user.lastName  = dict[@"last_name"];
    user.city      = dict[@"location"][@"name"];
    user.avatar    = [NSString stringWithFormat:kAvatar, dict[@"id"]];
    user.female    = ([@"female" caseInsensitiveCompare:dict[@"gender"]] == NSOrderedSame);
    
    return user;
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
