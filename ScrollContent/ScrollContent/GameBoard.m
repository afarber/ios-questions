#import "GameBoard.h"

CGFloat const kBoardWidth  = 780.0f;
CGFloat const kBoardHeight = 780.0f;
CGFloat const kBoardTop    = 53.0f;
CGFloat const kBoardLeft   = 53.0f;

@implementation GameBoard

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* result = [super hitTest:point withEvent:event];
    
    NSLog(@"%s: result=%@ root=%@", __PRETTY_FUNCTION__, result, self.window.rootViewController.view);

    return result == self ? nil : self.window.rootViewController.view;
}

@end
