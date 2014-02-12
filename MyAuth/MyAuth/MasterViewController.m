#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "MasterViewController.h"
#import "LoginViewController.h"
#import "UserViewController.h"
#import "SocialNetwork.h"
#import "OAuth/Facebook.h"
#import "OAuth/Google.h"
#import "OAuth/Mailru.h"
#import "OAuth/Odnoklassniki.h"
#import "OAuth/Vkontakte.h"

static NSString* const kFacebookAppId = @"441988749325-h8bsf01r3jnv5nbsb31a8pi99660oe0q.apps.googleusercontent.com";

@interface MasterViewController() {
    NSDictionary* _menu;
    
    ACAccount* _facebookAccount;
    ACAccountType* _facebookAccountType;
    ACAccountStore* _accountStore;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _menu = @{
              kFB:  @{
                      kKey:      kFB,
                      kLabel:    @"Facebook",
                      kObj:      [[Facebook alloc] init],
                      },
              kGG:  @{
                      kKey:      kGG,
                      kLabel:    @"Google+",
                      kObj:      [[Google alloc] init],
                      },
              kMR:   @{
                      kKey:      kMR,
                      kLabel:    @"Mail.ru",
                      kObj:      [[Mailru alloc] init],
                      },
              kOK:   @{
                      kKey:      kOK,
                      kLabel:    @"Odnoklassniki",
                      kObj:      [[Odnoklassniki alloc] init],
                      },
              kVK:   @{
                      kKey:      kVK,
                      kLabel:    @"VKontakte",
                      kObj:      [[Vkontakte alloc] init],
                      },
            };
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *keys = [User keys];
    return keys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSArray *keys = [User keys];
    NSString *key = keys[indexPath.row];
    NSString *label = _menu[key][kLabel];
    cell.textLabel.text = label;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSArray *keys = [User keys];
    NSString *key = keys[indexPath.row];
    //NSLog(@"%s: key=%@", __PRETTY_FUNCTION__, key);
    [User saveDefaultKey:key];
    User* user = [User loadForKey:key];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //MasterViewController *vc1 = [storyboard instantiateViewControllerWithIdentifier:@"Master"];
    LoginViewController *vc2 = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
    UserViewController *vc3 = [storyboard instantiateViewControllerWithIdentifier:@"User"];
    
    UINavigationController* nc = [self navigationController];
    
    if (user) {
        [nc pushViewController:vc3 animated:YES];
    } else if (key == kFB) {
        if (NO == [SLComposeViewController isAvailableForServiceType: SLServiceTypeFacebook]) {
            [self showAlert:@"There are no Facebook accounts configured. Please add or create a Facebook account in Settings."];
            return;
        }
        
        [self fetchFacebookUser];
    } else {
        NSDictionary *dict = _menu[key];
        [vc2 setTitle:dict[kLabel]];
        [vc2 setSn:dict[kObj]];
        [nc pushViewController:vc2 animated:YES];
    }
}

-(void)fetchFacebookUser
{
    if (!_accountStore) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    
    if (!_facebookAccountType) {
        _facebookAccountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    }
    
    NSDictionary *options = @{ ACFacebookAppIdKey: kFacebookAppId };
    
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

@end
