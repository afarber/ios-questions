//
//  ViewController.m
//  FailedBankCD
//
// Tutorial by Adam Burkepile
//

#import "ViewController.h"
#import "FailedBankDetails.h"
#import "FailedBankInfo.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize managedObjectContext;
@synthesize failedBankInfos;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"FailedBankInfo"
                                   inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    self.failedBankInfos = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    self.title = @"Failed Banks";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [failedBankInfos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    FailedBankInfo *info = [failedBankInfos objectAtIndex:indexPath.row];
    cell.textLabel.text = info.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@",
                                 info.city, info.state];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
