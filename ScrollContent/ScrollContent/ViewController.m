#import "ViewController.h"
#import "Tile.h"

static float const kTileScale = 1.0;
static int const kPadding     = 2;
static int const kNumTiles    = 7;

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _imageView.frame = CGRectMake(0, 0, 1000, 1000);
    _contentView.frame = CGRectMake(0, 0, 1000, 1000);
    _scrollView.contentSize = CGSizeMake(1000, 1000);

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

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self adjustZoom];
    [self adjustFrames];
}


- (void) adjustZoom
{
    float scale = _scrollView.frame.size.width / 1000;
    _scrollView.minimumZoomScale = scale;
    _scrollView.maximumZoomScale = 2 * scale;
    _scrollView.zoomScale = 2 * scale;
}

- (void) handleTileMoved:(NSNotification*)notification {
    Tile* tile = (Tile*)notification.object;
    NSLog(@"%s %@", __PRETTY_FUNCTION__, tile);
    //return;
    
    if (tile.superview != _contentView &&
        CGRectIntersectsRect(tile.frame, _scrollView.frame)) {
        [tile removeFromSuperview];
        [_contentView addSubview:tile];
        
        CGPoint pt = [self.view convertPoint:tile.frame.origin toView:_contentView];
        tile.frame = CGRectMake(
            pt.x + _scrollView.contentOffset.x * _scrollView.zoomScale,
            pt.y + _scrollView.contentOffset.y * _scrollView.zoomScale,
            kTileWidth,
            kTileHeight);
        
        //tile.transform = CGAffineTransformMakeScale(1.3, 1.3);

        
    } else if (tile.superview == _contentView &&
               !CGRectIntersectsRect(tile.frame, _scrollView.frame)) {
        [tile removeFromSuperview];
        [self.view addSubview:tile];
        [self adjustFrames];
    }
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
        
        //NSLog(@"tile: %@", tile);
    }
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
