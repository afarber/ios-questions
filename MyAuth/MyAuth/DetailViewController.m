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
        NSURL *url = [NSURL URLWithString:_dict[kAuthUrl]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
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

@end
