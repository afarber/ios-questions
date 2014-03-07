#import "ViewController.h"
#import "Tile.h"

static float const kScale  = 1.0;
static int const kPadding  = 2;
static int const kNumTiles = 7;
static int const kWidth    = 45;
static int const kHeight   = 45;

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%s: image %@",
          __PRETTY_FUNCTION__,
          NSStringFromCGSize(_imageView.image.size));
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleRotation:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    
    for (int i = 0; i < kNumTiles; i++) {
        Tile *tile = [[[NSBundle mainBundle] loadNibNamed:@"Tile"
                                                    owner:self
                                                  options:nil] firstObject];
        tile.frame = CGRectMake(
                                kPadding + i * (kWidth * kScale),
                                self.view.bounds.size.height - kHeight - kPadding,
                                kWidth,
                                kHeight);
        
        //tile.transform = CGAffineTransformMakeScale(kScale, kScale);
        tile.exclusiveTouch = YES;
        [self.view addSubview:tile];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    float minScale = MIN(
                         _scrollView.frame.size.width / _imageView.image.size.width,
                         _scrollView.frame.size.height / _imageView.image.size.height
                         );
    
    float zoomScale = _scrollView.frame.size.width / _imageView.image.size.width;
    
    float maxScale = MAX(
                         2 * _scrollView.frame.size.width / _imageView.image.size.width,
                         2 * _scrollView.frame.size.height / _imageView.image.size.height
                         );
    
    _scrollView.minimumZoomScale = minScale;
    _scrollView.maximumZoomScale = maxScale;
    _scrollView.zoomScale = zoomScale;

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

- (void)handleRotation:(NSNotification*)notification
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;

    NSLog(@"%s: orientation %d",
          __PRETTY_FUNCTION__,
          orientation);

    if(orientation == UIInterfaceOrientationLandscapeLeft ||
       orientation == UIInterfaceOrientationLandscapeRight) {
        //Do your textField animation here
    }
    
    // TODO adjust scroll view zoom
    // TODO move the tiles to the bottom
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView
{
    return _imageView;
}

- (IBAction)scrollViewDoubleTapped:(UITapGestureRecognizer*)sender
{
    CGPoint pointInView = [sender locationInView:_imageView];
    
    float zoomScale = _scrollView.frame.size.width / _imageView.image.size.width;
    if (_scrollView.zoomScale <= zoomScale) {
        zoomScale *= 2;
    }
    
    CGSize size = _scrollView.bounds.size;

    CGFloat w = size.width / zoomScale;
    CGFloat h = size.height / zoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rect = CGRectMake(x, y, w, h);
    [_scrollView zoomToRect:rect animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
