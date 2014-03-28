#import <UIKit/UIKit.h>
#import "Tile.h"

extern int const kBoardWidth;
extern int const kBoardHeight;
extern int const kBoardTop;
extern int const kBoardLeft;

@interface GameBoard: UIView
+ (CGPoint) snapToGrid:(CGPoint)pt;
@end
