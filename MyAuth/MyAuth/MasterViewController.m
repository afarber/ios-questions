#import <Social/Social.h>
//#import <Accounts/Accounts.h>
#import "MasterViewController.h"
#import "LoginViewController.h"
#import "UserViewController.h"
#import "GameCenterViewController.h"
#import "FacebookViewController.h"
#import "SocialNetwork.h"
//#import "OAuth/Facebook.h"
#import "OAuth/Google.h"
#import "OAuth/Mailru.h"
#import "OAuth/Odnoklassniki.h"
#import "OAuth/Vkontakte.h"

@interface MasterViewController() {
    NSDictionary* _menu;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _menu = @{
              kGC:  @{
                      kKey:      kGC,
                      kLabel:    @"Game Center",
                      },
              kFB:  @{
                      kKey:      kFB,
                      kLabel:    @"Facebook",
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
    GameCenterViewController *vc4 = [storyboard instantiateViewControllerWithIdentifier:@"GameCenter"];
    FacebookViewController *vc5 = [storyboard instantiateViewControllerWithIdentifier:@"Facebook"];
    
    UINavigationController* nc = [self navigationController];
    
    if (user) {
        [nc pushViewController:vc3 animated:YES];
    } else if (key == kGC) {
        [nc pushViewController:vc4 animated:YES];

    } else if (key == kFB) {
        if (NO == [SLComposeViewController isAvailableForServiceType: SLServiceTypeFacebook]) {
            [self showAlert:@"There are no Facebook accounts configured. Please add or create a Facebook account in Settings."];
            return;
        }
        
        [nc pushViewController:vc5 animated:YES];
    } else {
        NSDictionary *dict = _menu[key];
        [vc2 setTitle:dict[kLabel]];
        [vc2 setSn:dict[kObj]];
        [nc pushViewController:vc2 animated:YES];
    }
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
