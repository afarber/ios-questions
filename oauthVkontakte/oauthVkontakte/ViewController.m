#import "ViewController.h"
#import "DetailViewController.h"

static NSString* const kAppId =    @"4132525";
static NSString* const kSecret =   @"ar3IMdDaDzcUDUHj3rsl";
static NSString* const kAuthUrl =  @"http://oauth.vk.com/authorize?";
static NSString* const kRedirect = @"http://oauth.vk.com/blank.html";
static NSString* const kAvatar =   @"XXX %@ XXX";
static NSString* const kMe =       @"https://graph.facebook.com/me?";

static NSDictionary *_dict;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *redirect = [kRedirect stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *str = [NSString stringWithFormat:@"%@client_id=%@&response_type=token&display=touch&redirect_uri=%@",
                     kAuthUrl, kAppId, redirect];
    
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
    NSString *token = [self extractTokenFrom:str WithKey:@"access_token"];
    NSString *userId = [self extractTokenFrom:str WithKey:@"user_id"];
    NSLog(@"%s: %@ %@", __PRETTY_FUNCTION__, token, userId);
    
    if (token && userId) {
        [self fetchVkontakte:token];
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

- (void)fetchVkontakte:(NSString*)token
{
    NSString *str = [kMe stringByAppendingString:token];
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"pushDetailViewController"]) {
        DetailViewController *dvc = segue.destinationViewController;
        [dvc setDict:_dict];
    }
}

@end
