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
        tile.frame = CGRectMake(
            kPadding + i * (kWidth * kScale),
            self.view.bounds.size.height - kHeight - kPadding,
            kWidth,
            kHeight);
        
        //tile.transform = CGAffineTransformMakeScale(kScale, kScale);

        [self.view addSubview:tile];
    }
}

@end
