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
    
    float minScale = MIN(
                         _scrollView.frame.size.width / _imageView.image.size.width,
                         _scrollView.frame.size.height / _imageView.image.size.height
                         );
    
    float zoomScale = MIN(
                         2 * _scrollView.frame.size.width / _imageView.image.size.width,
                         2 * _scrollView.frame.size.height / _imageView.image.size.height
                         );
    
    float maxScale = MAX(
                         2 * _scrollView.frame.size.width / _imageView.image.size.width,
                         2 * _scrollView.frame.size.height / _imageView.image.size.height
                         );
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        _scrollView.minimumZoomScale = minScale;
        _scrollView.maximumZoomScale = maxScale;
        _scrollView.zoomScale = zoomScale;
    } else {
        _scrollView.minimumZoomScale = minScale;
        _scrollView.maximumZoomScale = maxScale;
        _scrollView.zoomScale = zoomScale;
    }

    _scrollView.contentSize = _imageView.frame.size;
    
    NSLog(@"%s: _scrollView %@ %@",
          __PRETTY_FUNCTION__,
          NSStringFromCGPoint(_scrollView.frame.origin),
          NSStringFromCGSize(_scrollView.frame.size));
    
    NSLog(@"%s: _imageView %@ %@",
          __PRETTY_FUNCTION__,
          NSStringFromCGPoint(_imageView.frame.origin),
          NSStringFromCGSize(_imageView.frame.size));
    
    NSLog(@"%s: minScale=%f zoomScale=%f maxScale=%f width=%f height=%f",
          __PRETTY_FUNCTION__,
          minScale,
          zoomScale,
          maxScale,
          (_scrollView.frame.size.width / _imageView.image.size.width),
          (_scrollView.frame.size.height / _imageView.image.size.height));
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
