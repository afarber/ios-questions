#import "MasterViewController.h"

#import "DetailViewController.h"

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
               @"FB": @"Facebook",
               @"GG": @"Google+",
               @"MR": @"Mail.ru",
               @"OK": @"Odnoklassniki",
               @"VK": @"Vkontakte",
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
    NSDate *object = _menu[key];
    cell.textLabel.text = [object description];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *key = _keys[indexPath.row];
        NSDate *object = _menu[key];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
