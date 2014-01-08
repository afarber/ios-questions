#import "ViewController.h"

/*
// Google+
static const NSString *kAppId =    @"441988749325-h8bsf01r3jnv5nbsb31a8pi99660oe0q.apps.googleusercontent.com";
static const NSString *kSecret =   @"YjnMME25A-2qvasUQbjM52vN";
static const NSString *kAuthUrl =  @"https://accounts.google.com/o/oauth2/auth?";
 static const NSString *kRedirect = @"urn:ietf:wg:oauth:2.0:oob";
static const NSString *kScope =    @"https://www.googleapis.com/auth/userinfo.profile";
*/

// Facebook
static const NSString *kAppId =    @"432298283565593";
static const NSString *kSecret =   @"c59d4f8cc0a15a0ad4090c3405729d8e";
static const NSString *kAuthUrl =  @"https://graph.facebook.com/oauth/authorize?";
static const NSString *kRedirect = @"https://www.facebook.com/connect/login_success.html";

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
    NSString *str = [NSString stringWithFormat:@"%@client_id=%@&response_type=token&redirect_uri=%@&state=%d", kAuthUrl, kAppId, redirect, state];

    NSURL *url = [NSURL URLWithString:str];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"GET"];
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, req);
    [_webView loadRequest:req];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSURL *url = [webView.request mainDocumentURL];
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, url);
    // TODO extract access token here
    NSString *str = [url absoluteString];
    NSString *token = [self extractToken:str];
    [self fetchFacebook:token];
}

- (NSString*)extractToken:(NSString*)str
{
    NSString *token = nil;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"access_token=\\w+"
                                                                      options:0
                                                                        error:nil];
    NSRange searchRange = NSMakeRange(0, [str length]);
    NSRange resultRange = [regex rangeOfFirstMatchInString:str options:0 range:searchRange];
    if (!NSEqualRanges(resultRange, NSMakeRange(NSNotFound, 0))) {
        token = [str substringWithRange:resultRange];
        NSLog(@"%s: %@", __PRETTY_FUNCTION__, token);
    }
    
    return token;
}

- (void)fetchFacebook:(NSString*)token
{
    NSString *str = [@"https://graph.facebook.com/me?" stringByAppendingString:token];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, url);
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection
     sendAsynchronousRequest:req
     queue:queue
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error) {
         
         if (error == nil && [data length] > 0) {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:NSJSONReadingMutableContainers
                                                                    error:nil];
             //NSLog(@"dict = %@", dict);
             NSLog(@"id: %@", dict[@"id"]);
             NSLog(@"first_name: %@", dict[@"first_name"]);
             NSLog(@"last_name: %@", dict[@"last_name"]);
             NSLog(@"gender: %@", dict[@"gender"]);
             NSLog(@"city: %@", dict[@"location"][@"name"]);
             
         } else {
             NSLog(@"Download failed: %@", error);
         }
     }];
}

@end
