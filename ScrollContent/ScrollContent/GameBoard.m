#import "GameBoard.h"

CGFloat const kBoardWidth  = 775.0f;
CGFloat const kBoardHeight = 775.0f;
CGFloat const kBoardTop    = 52.0f;
CGFloat const kBoardLeft   = 52.0f;

@implementation GameBoard

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* result = [super hitTest:point withEvent:event];
    
    return result == self ? nil : result;
}

+ (CGPoint) snapToGrid:(CGPoint)pt
{
    CGFloat x = kBoardLeft - 1.0 + (.5 + floorf((pt.x - kBoardLeft) / kTileWidth)) * kTileWidth;
    CGFloat y = kBoardTop  - 1.0 + (.5 + floorf((pt.y - kBoardTop) / kTileHeight)) * kTileHeight;
    
    return CGPointMake(x, y);
}

@end
