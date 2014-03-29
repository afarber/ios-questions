#import <UIKit/UIKit.h>
#import "Tile.h"

extern CGFloat const kBoardWidth;
extern CGFloat const kBoardHeight;
extern CGFloat const kBoardTop;
extern CGFloat const kBoardLeft;

@interface GameBoard: UIView
+ (CGPoint) snapToGrid:(CGPoint)pt;
@end
