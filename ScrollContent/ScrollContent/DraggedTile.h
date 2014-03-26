#import <UIKit/UIKit.h>

extern int const kDraggedTileWidth;
extern int const kDraggedTileHeight;

@interface DraggedTile: UIView

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *letter;
@property (weak, nonatomic) IBOutlet UILabel *value;

@end
