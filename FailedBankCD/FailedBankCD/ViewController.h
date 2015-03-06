//
//  ViewController.h
//  FailedBankCD
//
// Tutorial by Adam Burkepile
//

#import <UIKit/UIKit.h>

@interface ViewController : UITableViewController

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic,strong) NSArray *failedBankInfos;

@end

