#import "ViewController.h"
#import "Tile.h"

static int const kNumTiles = 5;

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (int i = 0; i < kNumTiles; i++) {
        Tile *tile = [[[NSBundle mainBundle] loadNibNamed:@"Tile"
                                                    owner:self
                                                  options:nil] firstObject];
        tile.frame = CGRectMake(10 + (int)arc4random_uniform(200),
                                10 + (int)arc4random_uniform(200),
                                100,
                                100);
        
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(dragTile:)];
        [tile addGestureRecognizer:recognizer];
        [self.view addSubview:tile];
    }
}

- (IBAction)dragTile:(UIPanGestureRecognizer *)recognizer
{
    Tile *tile = (Tile*)recognizer.view;
    
    if (recognizer.state == UIGestureRecognizerStateBegan ||
        recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [recognizer translationInView:[tile superview]];
        
        tile.dragged = YES;
        
        [tile setCenter:CGPointMake(tile.center.x + translation.x,
                                    tile.center.y + translation.y)];
        
        [recognizer setTranslation:CGPointZero inView:tile.superview];
    } else {
        tile.dragged = NO;
    }
}

@end
