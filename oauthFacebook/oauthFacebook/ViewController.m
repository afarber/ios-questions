#import "ViewController.h"
#import "DetailViewController.h"
#import "User.h"

static NSString* const kAppId =    @"432298283565593";
static NSString* const kSecret =   @"c59d4f8cc0a15a0ad4090c3405729d8e";
static NSString* const kAuthUrl =  @"https://graph.facebook.com/oauth/authorize?response_type=token&client_id=%@&redirect_uri=%@&state=%d";
static NSString* const kRedirect = @"https://www.facebook.com/connect/login_success.html";
static NSString* const kAvatar =   @"http://graph.facebook.com/%@/picture?type=large";
static NSString* const kMe =       @"https://graph.facebook.com/me?access_token=%@";

static User *_user;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    int state = arc4random_uniform(1000);
    NSString *redirect = [kRedirect stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *str = [NSString stringWithFormat:kAuthUrl, kAppId, redirect, state];
    
    NSURL *url = [NSURL URLWithString:str];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"GET"];
    NSLog(@"%s: req=%@", __PRETTY_FUNCTION__, req);
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
    NSString *str = [url absoluteString];
    NSString *token = [self extractValueFrom:str ForKey:@"access_token"];
    if (token) {
        [self fetchFacebookWithToken:token];
    }
}

- (NSString*)extractValueFrom:(NSString*)str ForKey:(NSString*)key
{
    NSString *value = nil;
    NSString *pattern = [key stringByAppendingString:@"=([^?&=]+)"];
    
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                      options:0
                                                                        error:nil];
    NSRange searchRange = NSMakeRange(0, [str length]);
    NSTextCheckingResult* result = [regex firstMatchInString:str options:0 range:searchRange];
    
    if (result) {
        value = [str substringWithRange:[result rangeAtIndex:1]];
        NSLog(@"%s: value=%@", __PRETTY_FUNCTION__, value);
    }
    
    return value;
}

- (void)fetchFacebookWithToken:(NSString*)token
{
    NSString *str = [NSString stringWithFormat:kMe, token];
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
             id json = [NSJSONSerialization JSONObjectWithData:data
                                                       options:NSJSONReadingMutableContainers
                                                         error:nil];
             NSLog(@"json=%@", json);
             
             if (![json isKindOfClass:[NSDictionary class]]) {
                 NSLog(@"Parsing response failed");
                 return;
             }
             
             NSDictionary *dict = json;
             
             _user = [[User alloc] init];
             _user.userId    = dict[@"id"];
             _user.firstName = dict[@"first_name"];
             _user.lastName  = dict[@"last_name"];
             _user.city      = dict[@"location"][@"name"];
             _user.avatar    = [NSString stringWithFormat:kAvatar, dict[@"id"]];
             _user.female    = ([@"female" caseInsensitiveCompare:dict[@"gender"]] == NSOrderedSame);
             
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
        [dvc setUser:_user];
    }
}

@end
