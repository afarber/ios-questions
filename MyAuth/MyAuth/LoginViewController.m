#import "LoginViewController.h"
#import "UserViewController.h"
#import "User.h"

@interface LoginViewController() {
    User *_user;
}
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURLRequest *req = [_sn loginReq];
    //NSLog(@"%s: req=%@", __PRETTY_FUNCTION__, req);
    [_webView loadRequest:req];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSURL *url = [webView.request mainDocumentURL];
    NSString *str = [url absoluteString];
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    //NSLog(@"%s: url=%@ str=%@ title=%@", __PRETTY_FUNCTION__, url, str, title);
    
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
    //NSLog(@"%s: req=%@", __PRETTY_FUNCTION__, req);
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
             //NSLog(@"json=%@", json);
             
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
    //NSLog(@"%s: req=%@", __PRETTY_FUNCTION__, req);
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
             //NSLog(@"json = %@", json);
             
             _user = [_sn createUserFromJson:json];
             [_user save];
             
             double delayInSeconds = 1;
             dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
             dispatch_after(delay, dispatch_get_main_queue(), ^(void){
                 [self performSegueWithIdentifier: @"replaceOauth" sender: self];
             });
         } else {
             NSLog(@"Download failed: %@", error);
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
