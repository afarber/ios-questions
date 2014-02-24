#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%s: image %@",
          __PRETTY_FUNCTION__,
          NSStringFromCGSize(_imageView.image.size));
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    /*
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        _imageView.frame = CGRectMake(_imageView.frame.origin.x,
                                      _imageView.frame.origin.y,
                                      800, 800);
    }
    */
    
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
