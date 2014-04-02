#import <UIKit/UIKit.h>
#import "SmallTile.h"
#import "BigTile.h"
#import "GameBoard.h"

@interface ViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
