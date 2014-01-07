#import "ViewController.h"

static const NSString *kAppId =    @"441988749325.apps.googleusercontent.com";
static const NSString *kSecret =   @"HiXUUAQVTzIVZ_bvz1GYiYlb";
static const NSString *kRedirect = @"urn:ietf:wg:oauth:2.0:oob";
static const NSString *kAuthUrl =  @"https://accounts.google.com/o/oauth2/auth?";
static const NSString *kScope =    @"https://www.googleapis.com/auth/userinfo.profile";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    int state = arc4random_uniform(1000);
    NSString *redirect = [kRedirect stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *scope = [kScope stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *str = [NSString stringWithFormat:@"%@client_id=%@&response_type=code&redirect_uri=%@&scope=%@&state=%d",
           kAuthUrl, kAppId, redirect, scope, state];
    NSURL *url = [NSURL URLWithString:str];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    NSLog(@"request: %@", request);
    [_webView loadRequest:request];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
