#import <UIKit/UIKit.h>
#import "SmallTile.h"

extern CGFloat const kBoardWidth;
extern CGFloat const kBoardHeight;
extern CGFloat const kBoardTop;
extern CGFloat const kBoardLeft;

typedef struct Pos {
    NSInteger i;
    NSInteger j;
} Pos;

CG_INLINE Pos PosMake(NSInteger i, NSInteger j) {
    Pos pos;
    
    pos.i = i;
    pos.j = j;
    
    return pos;
}

CG_INLINE Pos PosFromXY(CGFloat x, CGFloat y) {
    Pos pos;
    
    pos.i = floorf((x - kBoardLeft) / kSmallTileWidth);
    pos.j = floorf((y - kBoardTop) / kSmallTileHeight);
    
    if (pos.i < 0) {
        pos.i = 0;
    } else if (pos.i > 14) {
        pos.i = 14;
    }
    
    if (pos.j < 0.0) {
        pos.j = 0.0;
    } else if (pos.j > 14.0) {
        pos.j = 14.0;
    }
    
    //NSLog(@"i=%f", pos.i);
    //NSLog(@"j=%f", pos.j);

    return pos;
}

@interface GameBoard: UIView
+ (CGPoint) snapToGrid:(CGPoint)pt;
@end
