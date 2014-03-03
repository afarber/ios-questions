#import "ViewController.h"

static int const kNumTiles = 5;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage* tile = [UIImage imageNamed:@"tile"];
    UIImage* dragged = [UIImage imageNamed:@"dragged"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    for (int i = 0; i < kNumTiles; i++) {
        // TODO: add a Tile to the VC here
    }
}

- (IBAction)dragTile:(UIPanGestureRecognizer *)recognizer
{
    UIView *tile = recognizer.view;
    
    if (recognizer.state == UIGestureRecognizerStateBegan ||
        recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [recognizer translationInView:[tile superview]];
        
        [tile setCenter:CGPointMake(tile.center.x + translation.x,
                                    tile.center.y + translation.y)];
        
        [recognizer setTranslation:CGPointZero inView:tile.superview];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
