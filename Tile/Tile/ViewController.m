#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    DraggedTile *tile = [[[NSBundle mainBundle] loadNibNamed:@"DraggedTile"
                                                       owner:self
                                                     options:nil] firstObject];
    tile.frame = CGRectMake(10 + arc4random_uniform(100),
                            10 + arc4random_uniform(100),
                            2 * kWidth,
                            2 * kHeight);
    [self.view addSubview:tile];

}

@end
