#import "ViewController.h"
#import "DetailViewController.h"
#import "User.h"

static NSString* const kAppId =    @"441988749325-h8bsf01r3jnv5nbsb31a8pi99660oe0q.apps.googleusercontent.com";
static NSString* const kSecret =   @"YjnMME25A-2qvasUQbjM52vN";
static NSString* const kAuthUrl =  @"https://accounts.google.com/o/oauth2/auth?response_type=code&scope=profile&client_id=%@&redirect_uri=%@&state=%d";
static NSString* const kRedirect = @"urn:ietf:wg:oauth:2.0:oob";
static NSString* const kTokenUrl = @"https://accounts.google.com/o/oauth2/token";
static NSString* const kBody =     @"grant_type=authorization_code&code=%@&client_id=%@&redirect_uri=%@&client_secret=%@";
static NSString* const kMe =       @"https://www.googleapis.com/oauth2/v1/userinfo?access_token=";

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
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"%s: title=%@", __PRETTY_FUNCTION__, title);

    NSString *token = [self extractValueFrom:title ForKey:@"code"];
    if (token) {
        [self fetchGoogle1:token];
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

- (void)fetchGoogle1:(NSString*)token
{
    NSString *redirect = [kRedirect stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:kTokenUrl];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"POST"];
    
    NSString *body = [NSString stringWithFormat:kBody,
                     token, kAppId, redirect, kSecret];
    [req setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];

    NSLog(@"%s: req=%@", __PRETTY_FUNCTION__, req);
    
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
             
             NSString *token = dict[@"access_token"];
             NSLog(@"token=%@", token);
             [self fetchGoogle2:token];
         } else {
             NSLog(@"Download failed: %@", error);
         }
     }];
}


- (void)fetchGoogle2:(NSString*)token
{
    NSString *str = [kMe stringByAppendingString:token];
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
             NSLog(@"dict = %@", dict);
             
             
             if (dict) {
                 _user = [[User alloc] init];
                 _user.userId    = dict[@"id"];
                 _user.firstName = dict[@"given_name"];
                 _user.lastName  = dict[@"family_name"];
                 //_user.city    = dict[@"PlacesLived"][0][@"value"];
                 _user.avatar    = dict[@"picture"];
                 _user.female    = ([@"female" caseInsensitiveCompare:dict[@"gender"]] == NSOrderedSame);
                 
                 dispatch_async(dispatch_get_main_queue(), ^(void) {
                     [self performSegueWithIdentifier: @"pushDetailViewController" sender: self];
                 });
             }
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
