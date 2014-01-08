#import "DetailViewController.h"
#import "Keys.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDict:(NSDictionary*)newDict
{
    if (_dict != newDict) {
        _dict = newDict;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (_dict) {
        NSString *str = [self buildUrl];
        NSURL *url = [NSURL URLWithString:str];
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
        [req setHTTPMethod:@"GET"];
        NSLog(@"request: %@", req);
        [_webView loadRequest:req];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*)buildUrl
{
    NSString *key = _dict[kKey];
    NSString *str = _dict[kAuthUrl];
    int state = arc4random_uniform(1000);
    NSString *redirect = [_dict[kRedirect] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  
    if ([key isEqual: kFB]) {
        str = [NSString stringWithFormat:@"%@client_id=%@&response_type=token&redirect_uri=%@&state=%d",
               _dict[kAuthUrl], _dict[kAppId], redirect, state];
    } else if ([key isEqual: kGG]) {
        NSString *scope = [_dict[kScope] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        str = [NSString stringWithFormat:@"%@client_id=%@&response_type=code&redirect_uri=%@&scope=%@&state=%d",
               _dict[kAuthUrl], _dict[kAppId], redirect, scope, state];
    } else if ([key isEqual: kMR]) {
    } else if ([key isEqual: kOK]) {
    } else if ([key isEqual: kVK]) {
    }
    
    return str;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSURL *url = [webView.request mainDocumentURL];
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, url);
    // TODO extract access token here
}


@end
