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
    CGFloat i = floorf((pt.x - kBoardLeft) / kTileWidth);
    CGFloat j = floorf((pt.y - kBoardTop) / kTileHeight);
    
    if (i < 0.0) {
        i = 0.0;
    } else if (i > 14.0) {
        i = 14.0;
    }
    
    if (j < 0.0) {
        j = 0.0;
    } else if (j > 14.0) {
        j = 14.0;
    }
    
    NSLog(@"i=%f", i);
    NSLog(@"j=%f", j);

    CGFloat x = kBoardLeft + (.5 + i) * kTileWidth;
    CGFloat y = kBoardTop  + (.5 + j) * kTileHeight;
    
    return CGPointMake(x, y);
}

@end
