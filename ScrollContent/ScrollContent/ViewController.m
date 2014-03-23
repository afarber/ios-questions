#import "ViewController.h"
#import "Tile.h"

static float const kTileScale = 1.0;
static int const kPadding     = 2;
static int const kNumTiles    = 7;

@implementation ViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    for (int i = 0; i < kNumTiles; i++) {
        Tile *tile = [[[NSBundle mainBundle] loadNibNamed:@"Tile"
                                                    owner:self
                                                  options:nil] firstObject];
        tile.exclusiveTouch = YES;
        [self.view addSubview:tile];
        
        [center addObserver:self
                   selector:@selector(handleTileTouched:)
                       name:kTileTouched
                     object:tile];
        
        [center addObserver:self
                   selector:@selector(handleTileReleased:)
                       name:kTileReleased
                     object:tile];
    }
    
    [self adjustZoom];
    [self adjustTiles];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

    [self adjustZoom];
    [self adjustTiles];
}

- (void) handleTileTouched:(NSNotification*)notification {
    Tile* tile = (Tile*)notification.object;
    //_scrollView.userInteractionEnabled = NO;
    
    if (tile.superview == self.view) {
        [self.view bringSubviewToFront:tile];
    } else {
        CGPoint pt = [tile.superview convertPoint:tile.frame.origin toView:self.view];
        tile.frame = CGRectMake(
                                pt.x - _scrollView.contentOffset.x * _scrollView.zoomScale,
                                pt.y - _scrollView.contentOffset.y * _scrollView.zoomScale,
                                kTileWidth,
                                kTileHeight);
        
        [tile removeFromSuperview];
        tile.transform = CGAffineTransformIdentity;
        [self.view addSubview:tile];
    }
}

- (void) handleTileReleased:(NSNotification*)notification {
    Tile* tile = (Tile*)notification.object;
    //_scrollView.userInteractionEnabled = YES;
    
    if (CGRectContainsRect(_scrollView.frame, tile.frame)) {
        NSLog(@"%s ADDING %d",
              __PRETTY_FUNCTION__,
              CGRectContainsRect(_scrollView.frame, tile.frame));

        [tile removeFromSuperview];
        [_contentView addSubview:tile];
        
        CGPoint pt = [self.view convertPoint:tile.frame.origin toView:_contentView];
        tile.frame = CGRectMake(
            pt.x + _scrollView.contentOffset.x * _scrollView.zoomScale,
            pt.y + _scrollView.contentOffset.y * _scrollView.zoomScale,
            kTileWidth,
            kTileHeight);
        
        tile.transform = CGAffineTransformMakeScale(2 * _scrollView.zoomScale,
                                                    2 * _scrollView.zoomScale);
    } else {
        [self adjustTiles];
    }
    
    NSLog(@"%s %@", __PRETTY_FUNCTION__, tile);
}

- (void) adjustZoom
{
    float scale = _scrollView.frame.size.width / 1000;
    _scrollView.minimumZoomScale = scale;
    _scrollView.maximumZoomScale = 2 * scale;
    _scrollView.zoomScale = 2 * scale;
}

- (void) adjustTiles
{
    int i = 0;
    for (UIView *subView in self.view.subviews) {
        if (![subView isKindOfClass:[Tile class]])
            continue;
        
        Tile* tile = (Tile*)subView;
        tile.frame = CGRectMake(kPadding + kTileWidth * kTileScale * i++,
                                self.view.bounds.size.height - kTileHeight * kTileScale - kPadding,
                                kTileWidth,
                                kTileHeight);
        
        //NSLog(@"tile: %@", tile);
    }
}

- (UIView*) viewForZoomingInScrollView:(UIScrollView*)scrollView
{
    return _contentView;
}

- (IBAction) scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer
{
    CGPoint pt = [recognizer locationInView:_contentView];
    CGFloat scale = (_scrollView.zoomScale < _scrollView.maximumZoomScale ?
                     _scrollView.maximumZoomScale :
                     _scrollView.minimumZoomScale);
    
    CGSize size = _scrollView.bounds.size;
    
    CGFloat w = size.width / scale;
    CGFloat h = size.height / scale;
    CGFloat x = pt.x - (w / 2.0f);
    CGFloat y = pt.y - (h / 2.0f);
    
    CGRect rect = CGRectMake(x, y, w, h);
    
    [self.scrollView zoomToRect:rect animated:YES];
    
    NSLog(@"%s offset=%@ size=%@ min=%f zoom=%f max=%f",
          __PRETTY_FUNCTION__,
          NSStringFromCGPoint(_scrollView.contentOffset),
          NSStringFromCGSize(_scrollView.contentSize),
          _scrollView.minimumZoomScale,
          _scrollView.zoomScale,
          _scrollView.maximumZoomScale
    );
    
    [self adjustTiles];
}

@end
