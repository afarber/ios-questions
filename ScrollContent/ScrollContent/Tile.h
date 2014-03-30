#import <UIKit/UIKit.h>
#import "DraggedTile.h"

extern int const kTileWidth;
extern int const kTileHeight;

@interface Tile: UIView

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *letter;
@property (weak, nonatomic) IBOutlet UILabel *value;

- (DraggedTile*)cloneTile;

@end
