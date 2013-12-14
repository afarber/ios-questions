#import "MasterViewController.h"
#import "DetailViewController.h"

static const NSArray *TITLES;

typedef NS_ENUM(NSInteger, menuItem) {
    kYourMove,
    kTheirMove,
    kWonGames,
    kLostGames,
    kOptions
};

@interface MasterViewController () {
    NSMutableArray *_menu;
}
@end

@implementation MasterViewController

+ (void)initialize
{
    // do not run for derived classes
    if (self != [MasterViewController class])
        return;
    
    TITLES = @[
        @"Your Move",
        @"Their Move",
        @"Won Games",
        @"Lost Games",
        @"Options"
    ];
}

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    
    NSMutableArray *_yourMove  = [[NSMutableArray alloc] initWithObjects:
                  [self randGameStr],
                  [self randGameStr],
                  [self randGameStr],
                  [self randGameStr],
                  [self randGameStr],
                  nil];
    NSMutableArray *_theirMove = [[NSMutableArray alloc] initWithObjects:
                 [self randGameStr],
                 [self randGameStr],
                 [self randGameStr],
                 [self randGameStr],
                 [self randGameStr],
                 nil];
    NSMutableArray *_wonGames  = [[NSMutableArray alloc] initWithObjects:
                 [self randGameStr],
                 [self randGameStr],
                 [self randGameStr],
                 [self randGameStr],
                 [self randGameStr],
                 nil];
    NSMutableArray *_lostGames = [[NSMutableArray alloc] initWithObjects:
                 [self randGameStr],
                 [self randGameStr],
                 [self randGameStr],
                 [self randGameStr],
                 [self randGameStr],
                 nil];
    NSMutableArray *_options   = [[NSMutableArray alloc] initWithObjects:
                 [self randGameStr],
                 [self randGameStr],
                 [self randGameStr],
                 [self randGameStr],
                 nil];

    _menu = [[NSMutableArray alloc] initWithObjects:
             _yourMove,
             _theirMove,
             _wonGames,
             _lostGames,
             _options,
             nil];
             

    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    /*
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
     */
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_menu objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return TITLES[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = [[_menu objectAtIndex: indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
     */
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSDate *object = _objects[indexPath.row];
        self.detailViewController.detailItem = object;
    }
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /*
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
     */
}

- (NSString *)randGameStr
{
    int randomValue = rand() % 10000;

    NSString *str = [[NSString alloc] initWithFormat:@"Game #%u", randomValue];
    
    return str;
}

@end
