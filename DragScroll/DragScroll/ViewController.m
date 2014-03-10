#import "ViewController.h"
#import "Tile.h"

static float const kTileScale = 1.0;
static int const kPadding     = 2;
static int const kNumTiles    = 7;

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%s: image %@",
          __PRETTY_FUNCTION__,
          NSStringFromCGSize(_imageView.image.size));
    
    _imageView.frame = CGRectMake(0, 0, 1000, 1000);
    _scrollView.contentSize = _imageView.frame.size;
    _scrollView.canCancelContentTouches = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    for (int i = 0; i < kNumTiles; i++) {
        Tile *tile = [[[NSBundle mainBundle] loadNibNamed:@"Tile"
                                                    owner:self
                                                  options:nil] firstObject];
        
        //tile.transform = CGAffineTransformMakeScale(kTileScale, kTileScale);
        tile.exclusiveTouch = YES;
        [self.view addSubview:tile];
        
        [center addObserver:self
                   selector:@selector(handleTileMoved:)
                       name:kTileMoved
                     object:tile];
    }
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSLog(@"%s contentOffset %@",
          __PRETTY_FUNCTION__,
          NSStringFromCGPoint(_scrollView.contentOffset));
    
    _scrollView.contentSize = _imageView.frame.size;
    
    [self adjustFrames];
    [self adjustZoom];
}

- (void) adjustFrames
{
    _scrollView.frame = CGRectMake(0,
                                   0,
                                   self.view.bounds.size.width,
                                   self.view.bounds.size.height - kTileHeight - 2 * kPadding);
    
    int i = 0;
    for (UIView *subView in self.view.subviews) {
        if (![subView isKindOfClass:[Tile class]])
            continue;
        
        Tile* tile = (Tile*)subView;
        if (tile.dragged)
            continue;
        
        tile.frame = CGRectMake(kPadding + kTileWidth * kTileScale * i++,
                                self.view.bounds.size.height - kTileHeight * kTileScale - kPadding,
                                kTileWidth,
                                kTileHeight);
        
        NSLog(@"tile: %@", tile);
    }
}

- (void) adjustZoom
{
    float minScale = _scrollView.frame.size.width / _imageView.image.size.width;
    float maxScale = 2 * minScale;
    
    _scrollView.minimumZoomScale = minScale;
    _scrollView.maximumZoomScale = maxScale;
    _scrollView.zoomScale = maxScale;
    
    NSLog(@"%s: _scrollView %@ %@",
          __PRETTY_FUNCTION__,
          NSStringFromCGPoint(_scrollView.frame.origin),
          NSStringFromCGSize(_scrollView.frame.size));
    
    NSLog(@"%s: _imageView %@ %@",
          __PRETTY_FUNCTION__,
          NSStringFromCGPoint(_imageView.frame.origin),
          NSStringFromCGSize(_imageView.frame.size));
    
    NSLog(@"%s: minScale=%f maxScale=%f",
          __PRETTY_FUNCTION__,
          minScale,
          maxScale);
}

- (void) handleTileMoved:(NSNotification*)notification {
    Tile* tile = (Tile*)notification.object;
    NSLog(@"%s %@",
          __PRETTY_FUNCTION__,
          tile);
    
    if (tile.superview != _scrollView && CGRectIntersectsRect(tile.frame, _scrollView.frame)) {
        [tile removeFromSuperview];
        [_scrollView addSubview:tile];
    } else if (tile.superview == _scrollView && !CGRectIntersectsRect(tile.frame, _scrollView.frame)) {
        [tile removeFromSuperview];
        [self.view addSubview:tile];
        [self adjustFrames];
    }
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView
{
    return _imageView;
}

- (IBAction)scrollViewDoubleTapped:(UITapGestureRecognizer*)sender
{
    if (_scrollView.zoomScale < _scrollView.maximumZoomScale)
        [_scrollView setZoomScale:_scrollView.maximumZoomScale animated:YES];
    else
        [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
}

@end
