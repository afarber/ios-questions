#import "ReplaceSegue.h"

@implementation ReplaceSegue

-(void)perform {
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    // Pop to root view controller (not animated) before pushing
    [sourceViewController.navigationController popToRootViewControllerAnimated:NO];
    [sourceViewController.navigationController pushViewController:destinationController animated:YES];
}

@end
