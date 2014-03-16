#import "GameBoard.h"
#import "Tile.h"

@implementation GameBoard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    NSLog(@"%s: %@ %@ %hhd",
          __PRETTY_FUNCTION__,
          NSStringFromCGPoint(point),
          event,
          [super pointInside:point withEvent:event]);
    
    return [super pointInside:point withEvent:event];
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* result = [super hitTest:point withEvent:event];
    
    /*
    NSLog(@"%s: %@ %hhd", __PRETTY_FUNCTION__, result,
          [result.superview isKindOfClass:[Tile class]]);
    */
    
    //self.scrollEnabled = ![result.superview isKindOfClass:[Tile class]];
    return result;
}

@end
