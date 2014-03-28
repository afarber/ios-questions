#import "GameBoard.h"
#import "Tile.h"

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

@end
