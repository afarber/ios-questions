#import "ReplaceSegue.h"

@implementation ReplaceSegue

-(void)perform {
    UIViewController *source = (UIViewController*)[self sourceViewController];
    UIViewController *destination = (UIViewController*)[self destinationViewController];
    UINavigationController *navigationController = source.navigationController;
    
    [navigationController popToRootViewControllerAnimated:NO];
    [navigationController pushViewController:destination animated:YES];
}

@end
