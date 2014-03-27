#import "DraggedTile.h"

int const kWidth  = 128;
int const kHeight = 128;

@implementation DraggedTile

- (NSString*)description
{
    return [NSString stringWithFormat:@"DraggedTile %@ %@ %@ %@",
            _letter.text,
            _value.text,
            NSStringFromCGPoint(self.frame.origin),
            NSStringFromCGSize(self.frame.size)];
}

@end
