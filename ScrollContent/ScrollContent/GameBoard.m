#import "GameBoard.h"

int const kBoardWidth  = 775;
int const kBoardHeight = 775;
int const kBoardTop    = 52;
int const kBoardLeft   = 52;

@implementation GameBoard

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* result = [super hitTest:point withEvent:event];
    
    return result == self ? nil : result;
}

+ (CGPoint) snapToGrid:(CGPoint)pt
{
    CGFloat x = kBoardLeft - 1 + (((int)pt.x - kBoardLeft) / kTileWidth + .5) * kTileWidth;
    CGFloat y = kBoardTop  - 1 + (((int)pt.y - kBoardTop) / kTileHeight + .5) * kTileHeight;
    
    return CGPointMake(x, y);
}

@end
