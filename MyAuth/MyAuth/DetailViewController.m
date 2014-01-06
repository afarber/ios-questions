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
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        NSLog(@"request: %@", request);
        [_webView loadRequest:request];
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
  
    if ([key isEqual: kFB]) {
        str = [str stringByAppendingString:@"display=touch"];
        str = [str stringByAppendingString:@"&response_time=token"];
        str = [str stringByAppendingString:@"&client_id="];
        str = [str stringByAppendingString:_dict[kAppId]];
        str = [str stringByAppendingString:@"&redirect_uri="];
        str = [str stringByAppendingString:_dict[kAppUrl]];
        //str = [str stringByAppendingString:@"&state="];
        //str = [str stringByAppendingString:rand(1000)];
    } else if ([key isEqual: kGG]) {
    } else if ([key isEqual: kMR]) {
    } else if ([key isEqual: kOK]) {
    } else if ([key isEqual: kVK]) {
    }
    
    return str;
}

@end
