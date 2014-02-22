#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *img = [UIImage imageNamed:@"board"];
    NSLog(@"%s: (%f x %f)", __PRETTY_FUNCTION__, img.size.width, img.size.height);
    _imageView.image = img;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _scrollView.contentSize = _imageView.bounds.size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
