#import "MasterViewController.h"
#import "LoginViewController.h"
#import "UserViewController.h"
#import "SocialNetwork.h"
#import "OAuth/Facebook.h"
#import "OAuth/Google.h"
#import "OAuth/Mailru.h"
#import "OAuth/Odnoklassniki.h"
#import "OAuth/Vkontakte.h"

@interface MasterViewController () {
    NSDictionary *_menu;
    NSArray *_keys;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _keys = @[kFB, kGG, kMR, kOK, kVK];
        
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
    return _keys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSString *key = _keys[indexPath.row];
    NSString *label = _menu[key][kLabel];
    cell.textLabel.text = label;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *key = _keys[indexPath.row];
    NSLog(@"%s: key=%@", __PRETTY_FUNCTION__, key);
    [User saveDefaultKey:key];
    User* user = [User loadForKey:key];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //MasterViewController *vc1 = [storyboard instantiateViewControllerWithIdentifier:@"Master"];
    LoginViewController *vc2 = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
    UserViewController *vc3 = [storyboard instantiateViewControllerWithIdentifier:@"User"];
    
    UINavigationController* nc = [self navigationController];
    
    if (user) {
        [nc pushViewController:vc3 animated:YES];
    } else {
        NSDictionary *dict = _menu[key];
        [vc2 setTitle:dict[kLabel]];
        [vc2 setSn:dict[kObj]];
        [nc pushViewController:vc2 animated:YES];
    }
}

@end
