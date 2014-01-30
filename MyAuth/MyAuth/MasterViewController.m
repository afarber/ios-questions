#import "MasterViewController.h"
#import "LoginViewController.h"
#import "Keys.h"
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"pushLoginViewController"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *key = _keys[indexPath.row];
        NSDictionary *dict = _menu[key];
        [[segue destinationViewController] setTitle:dict[kLabel]];
        [[segue destinationViewController] setSn:dict[kObj]];
    }
}

@end
