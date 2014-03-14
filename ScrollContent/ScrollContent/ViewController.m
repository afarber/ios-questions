#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _imageView.frame = CGRectMake(0, 0, 1000, 1000);
    _contentView.frame = CGRectMake(0, 0, 1000, 1000);
    _scrollView.contentSize = CGSizeMake(1000, 1000);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    float scale = _scrollView.frame.size.width / 1000;
    
    _scrollView.minimumZoomScale = scale;
    _scrollView.maximumZoomScale = 2 * scale;
    _scrollView.zoomScale = 2 * scale;
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView
{
    return _contentView;
}

- (IBAction)scrollViewDoubleTapped:(UITapGestureRecognizer*)sender
{
    if (_scrollView.zoomScale < _scrollView.maximumZoomScale)
        [_scrollView setZoomScale:_scrollView.maximumZoomScale animated:YES];
    else
        [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
    
    NSLog(@"%s offset=%@ size=%@ min=%f zoom=%f max=%f",
          __PRETTY_FUNCTION__,
          NSStringFromCGPoint(_scrollView.contentOffset),
          NSStringFromCGSize(_scrollView.contentSize),
          _scrollView.minimumZoomScale,
          _scrollView.zoomScale,
          _scrollView.maximumZoomScale
    );
}

@end
