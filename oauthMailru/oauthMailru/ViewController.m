#import <CommonCrypto/CommonDigest.h>
#import "ViewController.h"
#import "DetailViewController.h"
#import "User.h"

static NSString* const kAppId =    @"715360";
static NSString* const kSecret =   @"60648c6d79654e4b1d99abe784ff6f63";
static NSString* const kAuthUrl =  @"https://connect.mail.ru/oauth/authorize?response_type=token&display=touch&client_id=%@&redirect_uri=%@";
static NSString* const kRedirect = @"http://connect.mail.ru/oauth/success.html";
static NSString* const kParams =   @"%@app_id=%@method=users.getInfosession_key=%@uids=%@%@";
static NSString* const kMe =       @"http://www.appsmail.ru/platform/api?app_id=%@&method=users.getInfo&session_key=%@&uids=%@&sig=%@";

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
    NSString *sig = [self md5:[NSString stringWithFormat:kParams, userId, kAppId, token, userId, kSecret]];
    
    NSString *str = [NSString stringWithFormat:kMe, kAppId, token, userId, sig];
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
             
             if (![json isKindOfClass:[NSArray class]]) {
                 NSLog(@"Parsing response failed");
                 return;
             }
             
             NSDictionary *dict = json[0];
             
             _user = [[User alloc] init];
             _user.userId    = dict[@"uid"];
             _user.firstName = dict[@"first_name"];
             _user.lastName  = dict[@"last_name"];
             _user.city      = dict[@"location"][@"city"][@"name"];
             _user.avatar    = dict[@"pic_big"];
             _user.female    = [dict[@"sex"] boolValue];
             
             dispatch_async(dispatch_get_main_queue(), ^(void) {
                 [self performSegueWithIdentifier: @"pushDetailViewController" sender: self];
             });
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

- (NSString *) md5:(NSString *)input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5(cStr, strlen(cStr), digest);
    
    NSMutableString *str = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [str appendFormat:@"%02x", digest[i]];
    
    return str;
}

@end
