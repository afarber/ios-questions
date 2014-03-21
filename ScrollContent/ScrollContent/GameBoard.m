#import "GameBoard.h"
#import "Tile.h"

@implementation GameBoard

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* result = [super hitTest:point withEvent:event];
    
    return result;// == self ? nil : result;
}

@end
