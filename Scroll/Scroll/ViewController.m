#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *img = [UIImage imageNamed:@"board"];
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, NSStringFromCGSize(img.size));
    _imageView.image = img;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _scrollView.contentSize = _imageView.bounds.size;
    
    NSLog(@"%s: _scrollView %@ %@",
          __PRETTY_FUNCTION__,
          NSStringFromCGPoint(_scrollView.frame.origin),
          NSStringFromCGSize(_scrollView.frame.size));
    
    NSLog(@"%s: _imageView %@ %@",
          __PRETTY_FUNCTION__,
          NSStringFromCGPoint(_imageView.frame.origin),
          NSStringFromCGSize(_imageView.frame.size));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
