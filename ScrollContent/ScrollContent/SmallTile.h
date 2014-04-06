#import <UIKit/UIKit.h>
#import "BigTile.h"
#include "GameBoard.h"

extern int const kSmallTileWidth;
extern int const kSmallTileHeight;

typedef NS_OPTIONS(NSUInteger, Dir) {
    None      = 0,
    NorthWest = 1 << 0,
    North     = 1 << 1,
    NorthEast = 1 << 2,
    East      = 1 << 3
};

@interface SmallTile : UIView

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *letter;
@property (weak, nonatomic) IBOutlet UILabel *value;

@property (nonatomic) NSInteger col;
@property (nonatomic) NSInteger row;

- (BigTile*)cloneTile;
- (void)snapToGrid;

@end
