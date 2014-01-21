#import "ViewController.h"
#import "DetailViewController.h"
#import "User.h"

static NSString* const kAppId =    @"1392384";
static NSString* const kSecret =   @"BDCB7DC52AAFD28A1774D232";
static NSString* const kAuthUrl =  @"https://connect.mail.ru/oauth/authorize?response_type=token&display=touch&client_id=%@&redirect_uri=%@";
static NSString* const kRedirect = @"http://connect.mail.ru/oauth/success.html";
static NSString* const kMe =       @"http://www.appsmail.ru/platform/api?app_id=%@&method=users.getInfo&session_key=%@&uids=%@";

static User *_user;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *redirect = [kRedirect stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *str = [NSString stringWithFormat:kAuthUrl, kAppId, redirect];
    
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
    NSString *userId = [self extractValueFrom:str ForKey:@"x_mailru_vid"];
    NSLog(@"%s: %@ %@", __PRETTY_FUNCTION__, token, userId);
    
    if (token && userId) {
        [self fetchMailruWithToken:token ForUser:userId];
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

- (void)fetchMailruWithToken:(NSString*)token ForUser:(NSString*)userId
{
    NSString *str = [NSString stringWithFormat:kMe, kAppId, token, userId];
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
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:NSJSONReadingMutableContainers
                                                                    error:nil];
             NSLog(@"dict=%@", dict);
             
             if (dict) {
                 _user = [[User alloc] init];
                 _user.userId    = dict[@"uid"];
                 _user.firstName = dict[@"first_name"];
                 _user.lastName  = dict[@"last_name"];
                 _user.city      = dict[@"city"];
                 _user.avatar    = dict[@"pic_big"];
                 _user.female    = (0 != (long)dict[@"sex"]);
             
                 dispatch_async(dispatch_get_main_queue(), ^(void) {
                     [self performSegueWithIdentifier: @"pushDetailViewController" sender: self];
                 });
             }
         } else {
             NSLog(@"Download failed: %@", error);
         }
     }];
}

- (void) prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"pushDetailViewController"]) {
        DetailViewController *dvc = segue.destinationViewController;
        [dvc setUser:_user];
    }
}

@end
