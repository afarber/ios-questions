#import <UIKit/UIKit.h>
#import "BigTile.h"

extern int const kSmallTileWidth;
extern int const kSmallTileHeight;

@interface SmallTile : UIView

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *letter;
@property (weak, nonatomic) IBOutlet UILabel *value;

- (BigTile*)cloneTile;

@end
