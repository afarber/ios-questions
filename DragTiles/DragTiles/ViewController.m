#import "ViewController.h"
#import "Tile.h"

static int const kNumTiles = 5;
static int const kWidth    = 60;
static int const kHeight   = 60;

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (int i = 0; i < kNumTiles; i++) {
        Tile *tile = [[[NSBundle mainBundle] loadNibNamed:@"Tile"
                                                    owner:self
                                                  options:nil] firstObject];
        tile.frame = CGRectMake(
            (int)arc4random_uniform(self.view.bounds.size.width - kWidth),
            (int)arc4random_uniform(self.view.bounds.size.height - kHeight),
            kWidth,
            kHeight);
        
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(dragTile:)];
        recognizer.minimumNumberOfTouches = 1;
        recognizer.maximumNumberOfTouches = 1;
        [tile addGestureRecognizer:recognizer];
        [self.view addSubview:tile];
    }
}

- (IBAction)dragTile:(UIPanGestureRecognizer *)recognizer
{
    Tile* tile = (Tile*)recognizer.view;
    UIView* parent = tile.superview;
    
    if (recognizer.state == UIGestureRecognizerStateBegan ||
        recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [recognizer translationInView:parent];
        
        [tile setCenter:CGPointMake(tile.center.x + translation.x,
                                    tile.center.y + translation.y)];
        
        [recognizer setTranslation:CGPointZero inView:parent];
    }
}

@end
