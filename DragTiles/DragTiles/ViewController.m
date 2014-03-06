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
            i * kWidth,
            (int)arc4random_uniform(self.view.bounds.size.height - kHeight),
            kWidth,
            kHeight);
        
        [self.view addSubview:tile];
    }
}

@end
