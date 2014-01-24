#import "ViewController.h"
#import "DetailViewController.h"
#import "User.h"
#import "Google.h"

static User *_user;

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!_sn) {
        _sn = [[Google alloc] init];
    }
    
    NSURL *url = [NSURL URLWithString:[_sn buildLoginStr]];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
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
    NSLog(@"%s: str=%@", __PRETTY_FUNCTION__, str);
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"%s: title=%@", __PRETTY_FUNCTION__, title);

    if ([_sn shouldFetchToken]) {
        NSString *code = [_sn extractCodeFromStr:str FromTitle:title];
        if (code) {
            [self fetchWithCode:code];
        }
    } else {
        NSString *token = [_sn extractTokenFromStr:str FromTitle:title];
        if (token) {
            [self fetchWithToken:token];
        }
    }
}

- (void)fetchWithCode:(NSString*)code
{
    NSURLRequest *req = [_sn buildTokenUrlWithCode:code];
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
             
             NSString *token = [_sn extractTokenFromJson:json];
             if (token) {
                 [self fetchWithToken:token];
             }
         } else {
             NSLog(@"Download failed: %@", error);
         }
     }];
}


- (void)fetchWithToken:(NSString*)token
{
    NSURLRequest *req = [_sn buildMeUrlWithToken:token];
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"pushDetailViewController"]) {
        DetailViewController *dvc = segue.destinationViewController;
        [dvc setUser:_user];
    }
}

@end
