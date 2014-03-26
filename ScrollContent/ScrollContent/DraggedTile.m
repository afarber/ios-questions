#import "DraggedTile.h"
#import "GameBoard.h"

int const kDraggedTileWidth  = 128;
int const kDraggedTileHeight = 128;

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
