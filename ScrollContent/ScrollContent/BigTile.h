#import <UIKit/UIKit.h>

extern int const kBigTileWidth;
extern int const kBigTileHeight;

@interface BigTile : UIView

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *letter;
@property (weak, nonatomic) IBOutlet UILabel *value;

@end
