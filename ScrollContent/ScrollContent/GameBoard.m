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

+ (CGPoint) snapToGrid:(CGPoint)point
{
    Pos pos = PosFromXY(point.x, point.y);
    
    //NSLog(@"i=%f", pos.i);
    //NSLog(@"j=%f", pos.j);

    CGFloat x = kBoardLeft + (.5 + pos.i) * kSmallTileWidth;
    CGFloat y = kBoardTop  + (.5 + pos.j) * kSmallTileHeight;
    
    return CGPointMake(x, y);
}

@end
