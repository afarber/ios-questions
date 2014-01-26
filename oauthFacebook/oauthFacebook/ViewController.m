#import "ViewController.h"
#import "DetailViewController.h"
#import "User.h"
#import "Facebook.h"

static User *_user;

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!_sn) {
        _sn = [[Facebook alloc] init];
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
