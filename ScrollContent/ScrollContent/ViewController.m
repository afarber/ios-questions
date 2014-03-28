#import "ViewController.h"

static float const kTileScale = 1.0;
static int const kPadding     = 2;
static int const kNumTiles    = 7;

@implementation ViewController
{
	DraggedTile* _draggedTile;
}

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
                   selector:@selector(handleTileMoved:)
                       name:kTileMoved
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
	tile.alpha = 0;
    
	_draggedTile = [tile cloneTile];
    _draggedTile.center = [self.view convertPoint:tile.center fromView:tile.superview];

	[self.view addSubview:_draggedTile];
}

- (void)handleTileMoved:(NSNotification*)notification
{
	Tile* tile = (Tile*)notification.object;
	
    _draggedTile.center = [self.view convertPoint:tile.center fromView:tile.superview];
}

- (void) handleTileReleased:(NSNotification*)notification {
    Tile* tile = (Tile*)notification.object;
	tile.alpha = 1;
	
	[_draggedTile removeFromSuperview];
	_draggedTile = nil;
    
	UITouch* touch = notification.userInfo[@"touch"];
	CGPoint pt = [touch locationInView:_contentView];
	CGPoint ptTransform = CGPointApplyAffineTransform(pt, _contentView.transform);
	CGPoint ptView = [touch locationInView:self.view];
	
    if (tile.superview != _contentView &&
        // Is the tile over the scoll view?
        CGRectContainsPoint(_scrollView.frame, ptView) &&
        // Is the tile still over the game board - when it is zoomed out?
        CGRectContainsPoint(_contentView.frame, ptTransform)) {
		
        // Put the tile at the game board
        tile.center = pt;
		[tile removeFromSuperview];
        [_contentView addSubview:tile];
        
    } else if(!CGRectContainsPoint(_scrollView.frame, ptView) ||
           !CGRectContainsPoint(_contentView.frame, ptTransform)) {
        
        // Put the tile back to the stack
        [tile removeFromSuperview];
        [self.view addSubview:tile];
        [self adjustTiles];
	}
    
    if (tile.superview == _contentView &&
        _scrollView.zoomScale == _scrollView.minimumZoomScale) {
        [self zoomTo:pt];
    }
    
    NSLog(@"%s %@", __PRETTY_FUNCTION__, tile);
}

- (void) adjustZoom
{
    float scale = _scrollView.frame.size.width / kBoardWidth;
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
    if (_scrollView.zoomScale > _scrollView.minimumZoomScale) {
        [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
    } else {
        CGPoint pt = [recognizer locationInView:_contentView];
        [self zoomTo:pt];
    }
    
    [self adjustTiles];
}

- (void) zoomTo:(CGPoint)pt
{
    CGFloat scale = _scrollView.maximumZoomScale;
    CGSize size = _scrollView.bounds.size;
    
    CGFloat w = size.width / scale;
    CGFloat h = size.height / scale;
    CGFloat x = pt.x - (w / 2.0f);
    CGFloat y = pt.y - (h / 2.0f);
    
    CGRect rect = CGRectMake(x, y, w, h);
    
    [_scrollView zoomToRect:rect animated:YES];
}

@end
