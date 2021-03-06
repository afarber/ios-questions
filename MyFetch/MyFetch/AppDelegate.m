#import "AppDelegate.h"

@interface AppDelegate ()
@property (readonly) UIViewController *viewController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval: UIApplicationBackgroundFetchIntervalMinimum];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    _viewController = [[UIViewController alloc] init];
    [[_viewController view] setBackgroundColor: [UIColor yellowColor]];
    [_viewController setTitle: @"MyFetch"];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController: _viewController];
    [[self window] setRootViewController: nc];
    
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"Background fetch");
    
    NSError *e = nil;
    
    NSURL *url = [NSURL URLWithString: @"http://objectiveceeds.com/app/color.php"];
    
    NSData *d = [[NSData alloc] initWithContentsOfURL: url
                                              options: NSDataReadingUncached
                                                error: &e];
    
    if (e != nil)
    {
        NSLog(@"Fetch error %@", e);
        completionHandler(UIBackgroundFetchResultFailed);
        return;
    }
    
    e = nil;
    NSDictionary *colorDict = [NSJSONSerialization JSONObjectWithData: d
                                                              options: 0
                                                                error: &e];
    
    if (e != nil)
    {
        NSLog(@"JSON error %@", e);
        completionHandler(UIBackgroundFetchResultFailed);
        return;
    }
    
    CGFloat red = [[colorDict objectForKey: @"red"] floatValue];
    CGFloat green = [[colorDict objectForKey: @"green"] floatValue];
    CGFloat blue = [[colorDict objectForKey: @"blue"] floatValue];
    
    
    // update UI
    UIColor *newColor = [UIColor colorWithRed: red
                                        green: green
                                         blue: blue
                                        alpha: 1.0];
    
    [[_viewController view] setBackgroundColor: newColor];
    
    // fire Notification
    UILocalNotification *note = [[UILocalNotification alloc] init];
    [note setAlertBody: @"Color did change"];
    [[UIApplication sharedApplication] scheduleLocalNotification: note];
    
    // call Completition Handler
    completionHandler(UIBackgroundFetchResultNewData);
}

@end
