#import "ViewController.h"
#import "DetailViewController.h"

static NSString* const kAppId =    @"441988749325-h8bsf01r3jnv5nbsb31a8pi99660oe0q.apps.googleusercontent.com";
static NSString* const kSecret =   @"YjnMME25A-2qvasUQbjM52vN";
static NSString* const kAuthUrl =  @"https://accounts.google.com/o/oauth2/auth?";
static NSString* const kRedirect = @"urn:ietf:wg:oauth:2.0:oob";
static NSString* const kScope =    @"https://www.googleapis.com/auth/userinfo.profile";
static NSString* const kAvatar =   @"http://graph.facebook.com/%@/picture?type=large";

static NSString* const kTokenUrl = @"https://accounts.google.com/o/oauth2/token?";
static NSString* const kMe =       @"https://www.googleapis.com/oauth2/v1/userinfo?";

static NSDictionary *_dict;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    int state = arc4random_uniform(1000);
    NSString *redirect = [kRedirect stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *scope    = [kScope stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSString stringWithFormat:@"%@client_id=%@&response_type=code&redirect_uri=%@&scope=%@&state=%d", kAuthUrl, kAppId, redirect, scope, state];

    NSURL *url = [NSURL URLWithString:str];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"GET"];
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, req);
    [_webView loadRequest:req];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSURL *url = [webView.request mainDocumentURL];
    NSLog(@"%s: url=%@", __PRETTY_FUNCTION__, url);
   // NSString *str = [url absoluteString];
    NSString *str = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"%s: title=%@", __PRETTY_FUNCTION__, str);

    NSString *token = [self extractTokenFrom:str WithKey:@"code"];
    if (token) {
        [self fetchGoogle1:token];
    }
}

- (NSString*)extractTokenFrom:(NSString*)str WithKey:(NSString*)key
{
    NSString *token = nil;
    NSString *pattern = [key stringByAppendingString:@"=[^?&=]+"];

    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                      options:0
                                                                        error:nil];
    NSRange searchRange = NSMakeRange(0, [str length]);
    NSRange resultRange = [regex rangeOfFirstMatchInString:str options:0 range:searchRange];
    if (! NSEqualRanges(resultRange, NSMakeRange(NSNotFound, 0))) {
        token = [str substringWithRange:resultRange];
        NSLog(@"%s: token=%@", __PRETTY_FUNCTION__, token);
    }
    
    return token;
}

- (void)fetchGoogle1:(NSString*)token
{
    NSString *str = [kTokenUrl stringByAppendingString:token];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSLog(@"%s: url=%@", __PRETTY_FUNCTION__, url);
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection
     sendAsynchronousRequest:req
     queue:queue
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error) {
         
         if (error == nil && [data length] > 0) {
             _dict = [NSJSONSerialization JSONObjectWithData:data
                                                     options:NSJSONReadingMutableContainers
                                                       error:nil];
             //NSLog(@"dict = %@", dict);
             
             dispatch_async(dispatch_get_main_queue(), ^(void) {
                 [self performSegueWithIdentifier: @"pushDetailViewController" sender: self];
             });
             
         } else {
             NSLog(@"Download failed: %@", error);
         }
     }];
}


- (void)fetchGoogle2:(NSString*)token
{
    NSString *str = [kTokenUrl stringByAppendingString:token];
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
             _dict = [NSJSONSerialization JSONObjectWithData:data
                                                     options:NSJSONReadingMutableContainers
                                                       error:nil];
             //NSLog(@"dict = %@", dict);
             
             dispatch_async(dispatch_get_main_queue(), ^(void) {
                 [self performSegueWithIdentifier: @"pushDetailViewController" sender: self];
             });
             
         } else {
             NSLog(@"Download failed: %@", error);
         }
     }];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"pushDetailViewController"]) {
        DetailViewController *dvc = segue.destinationViewController;
        [dvc setDict:_dict];
    }
}

@end
