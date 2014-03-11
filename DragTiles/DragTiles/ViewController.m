#import "ViewController.h"
#import "Tile.h"

static float const kTileScale = 1.0;
static int const kPadding     = 2;
static int const kNumTiles    = 7;

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

- (void) handleTileMoved:(NSNotification*)notification {
    Tile* tile = (Tile*)notification.object;
    NSLog(@"%s %@",
          __PRETTY_FUNCTION__,
          tile);
}

@end
