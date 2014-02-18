#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *img = [UIImage imageNamed:@"board"];
    NSLog(@"%s: img=%@ (%f x %f)", __PRETTY_FUNCTION__, img, img.size.width, img.size.height);
    _imageView.image = img;
    _scrollView.contentSize = img.size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
