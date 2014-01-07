#import "ViewController.h"

/*
// Google+
static const NSString *kAppId =    @"441988749325-h8bsf01r3jnv5nbsb31a8pi99660oe0q.apps.googleusercontent.com";
static const NSString *kSecret =   @"YjnMME25A-2qvasUQbjM52vN";
static const NSString *kRedirect = @"urn:ietf:wg:oauth:2.0:oob";
static const NSString *kAuthUrl =  @"https://accounts.google.com/o/oauth2/auth?";
static const NSString *kScope =    @"https://www.googleapis.com/auth/userinfo.profile";
*/

// Facebook
static const NSString *kAppId =    @"432298283565593";
static const NSString *kSecret =   @"c59d4f8cc0a15a0ad4090c3405729d8e";
static const NSString *kRedirect = @"https://www.facebook.com/connect/login_success.html";
static const NSString *kAuthUrl =  @"https://graph.facebook.com/oauth/authorize?";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    int state = arc4random_uniform(1000);
    NSString *redirect = [kRedirect stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // Google+
    //NSString *scope    = [kScope stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSString *str = [NSString stringWithFormat:@"%@client_id=%@&response_type=code&redirect_uri=%@&scope=%@&state=%d", kAuthUrl, kAppId, redirect, scope, state];
    
    // Facebook
    NSString *str = [NSString stringWithFormat:@"%@client_id=%@&display=touch&response_time=token&redirect_uri=%@&state=%d", kAuthUrl, kAppId, redirect, state];

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
