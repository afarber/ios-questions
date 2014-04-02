#import "GameBoard.h"

CGFloat const kBoardWidth  = 780.0f;
CGFloat const kBoardHeight = 780.0f;
CGFloat const kBoardTop    = 53.0f;
CGFloat const kBoardLeft   = 53.0f;

@implementation GameBoard

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* result = [super hitTest:point withEvent:event];
    
    return result == self ? nil : self.window.rootViewController.view;
}

+ (CGPoint) snapToGrid:(CGPoint)pt
{
    CGFloat i = floorf((pt.x - kBoardLeft) / kSmallTileWidth);
    CGFloat j = floorf((pt.y - kBoardTop) / kSmallTileHeight);
    
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
    
    //NSLog(@"i=%f", i);
    //NSLog(@"j=%f", j);

    CGFloat x = kBoardLeft + (.5 + i) * kSmallTileWidth;
    CGFloat y = kBoardTop  + (.5 + j) * kSmallTileHeight;
    
    return CGPointMake(x, y);
}

@end
