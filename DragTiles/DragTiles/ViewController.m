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
    
    for (int i = 0; i < kNumTiles; i++) {
        Tile *tile = [[[NSBundle mainBundle] loadNibNamed:@"Tile"
                                                    owner:self
                                                  options:nil] firstObject];
        //tile.transform = CGAffineTransformMakeScale(kScale, kScale);

        [self.view addSubview:tile];
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
        NSLog(@"tile before: %@", tile);
        
        if (tile.dragged)
            continue;
        
        tile.frame = CGRectMake(kPadding + kWidth * kScale * i++,
                                self.view.bounds.size.height - kHeight * kScale - kPadding,
                                kWidth,
                                kHeight);
        
        NSLog(@"tile after: %@", tile);
    }
}

@end
