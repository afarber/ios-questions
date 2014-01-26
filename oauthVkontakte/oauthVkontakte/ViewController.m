#import "ViewController.h"
#import "DetailViewController.h"
#import "User.h"
#import "Vkontakte.h"

static User *_user;

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!_sn) {
        _sn = [[Vkontakte alloc] init];
    }
    
    NSURLRequest *req = [_sn loginReq];
    NSLog(@"%s: req=%@", __PRETTY_FUNCTION__, req);
    [_webView loadRequest:req];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSURL *url = [webView.request mainDocumentURL];
    NSString *str = [url absoluteString];
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"%s: url=%@ str=%@ title=%@", __PRETTY_FUNCTION__, url, str, title);
    
    if ([_sn shouldFetchToken]) {
        NSURLRequest *req = [_sn tokenReqWithStr:str AndTitle:title];
        if (req) {
            [self fetchToken:req];
        }
    } else {
        NSURLRequest *req = [_sn userReqWithStr:str AndTitle:title];
        if (req) {
            [self fetchUser:req];
        }
    }
}

- (void)fetchToken:(NSURLRequest*)req
{
    NSLog(@"%s: req=%@", __PRETTY_FUNCTION__, req);
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
             
             NSURLRequest *req = [_sn userReqWithJson:json];
             if (req) {
                 [self fetchUser:req];
             }
         } else {
             NSLog(@"Download failed: %@", error);
         }
     }];
}

- (void)fetchUser:(NSURLRequest*)req
{
    NSLog(@"%s: req=%@", __PRETTY_FUNCTION__, req);
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
             NSLog(@"json = %@", json);
             
             _user = [_sn createUserFromJson:json];
             
             dispatch_async(dispatch_get_main_queue(), ^(void) {
                 [self performSegueWithIdentifier: @"pushDetailViewController" sender: self];
             });
         } else {
             NSLog(@"Download failed: %@", error);
         }
     }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushDetailViewController"]) {
        DetailViewController *dvc = segue.destinationViewController;
        [dvc setUser:_user];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

/*
 
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

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSURL *url = [webView.request mainDocumentURL];
    NSLog(@"%s: url=%@", __PRETTY_FUNCTION__, url);
    NSString *str = [url absoluteString];
    NSString *token = [self extractValueFrom:str ForKey:@"access_token"];
    NSString *userId = [self extractValueFrom:str ForKey:@"user_id"];
    NSLog(@"%s: %@ %@", __PRETTY_FUNCTION__, token, userId);
    
    if (token && userId) {
        [self fetchVkontakteWithToken:token ForUser:userId];
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

- (void)fetchVkontakteWithToken:(NSString*)token ForUser:(NSString*)userId
{
    NSString *str = [NSString stringWithFormat:kMe, userId, token];
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
             
             NSDictionary *dict = json[@"response"][0];

             _user = [[User alloc] init];
             _user.userId    = dict[@"uid"];
             _user.firstName = dict[@"first_name"];
             _user.lastName  = dict[@"last_name"];
             _user.city      = dict[@"city"];
             _user.avatar    = dict[@"photo_big"];
             _user.female    = (2 == [dict[@"female"] intValue]);
             
             dispatch_async(dispatch_get_main_queue(), ^(void) {
                 [self performSegueWithIdentifier: @"pushDetailViewController" sender: self];
             });
         } else {
             NSLog(@"Download failed: %@", error);
         }
     }];
}

*/
