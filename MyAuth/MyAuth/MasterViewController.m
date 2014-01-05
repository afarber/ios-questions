#import "MasterViewController.h"

#import "DetailViewController.h"

static NSString *kLabel   = @"label";
static NSString *kAppId   = @"app_id";
static NSString *kSecret  = @"secret";
static NSString *kAppUrl  = @"app_url";
static NSString *kAuthUrl = @"auth_url";

@interface MasterViewController () {
    NSDictionary *_menu;
    NSArray *_keys;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _keys = @[@"FB", @"GG", @"MR", @"OK", @"VK"];
        
    _menu = @{
              @"FB": @{
                      kLabel:   @"Facebook",
                      kAppId:   @"432298283565593",
                      kSecret:  @"c59d4f8cc0a15a0ad4090c3405729d8e",
                      kAppUrl:  @"https://www.facebook.com/connect/login_success.html",
                      kAuthUrl: @"https://graph.facebook.com/oauth/authorize?",
                      },
              @"GG": @{
                      kLabel:   @"Google+",
                      //kAppId:
                      //kSecret:
                      kAppUrl:  @"urn:ietf:wg:oauth:2.0:oob",
                      kAuthUrl: @"https://accounts.google.com/o/oauth2/auth?",
                      },
              @"MR": @{
                      kLabel:   @"Mail.ru",
                      kAppId:   @"715360",
                      kSecret:  @"4260eeea98d7665edbe4baa080af894b",
                      kAppUrl:  @"http://connect.mail.ru/oauth/success.html",
                      kAuthUrl: @"https://connect.mail.ru/oauth/authorize?",
                      },
              @"OK": @{
                      kLabel:   @"Odnoklassniki",
                      //kAppId:
                      //kSecret:
                      kAppUrl:  @"http://connect.mail.ru/oauth/success.html",
                      kAuthUrl: @"http://www.odnoklassniki.ru/oauth/authorize?",
                      },
              @"VK": @{
                      kLabel:   @"VKontakte",
                      //kAppId:
                      //kSecret:
                      kAppUrl:  @"http://oauth.vk.com/blank.html",
                      kAuthUrl: @"http://oauth.vk.com/authorize?",
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *key = _keys[indexPath.row];
        NSString *label = _menu[key][kLabel];
        [[segue destinationViewController] setDetailItem:label];
    }
}

@end
