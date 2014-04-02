#import "BigTile.h"

int const kBigTileWidth  = 128;
int const kBigTileHeight = 128;

@implementation BigTile

- (NSString*)description
{
    return [NSString stringWithFormat:@"BigTile %@ %@ %@ %@",
            _letter.text,
            _value.text,
            NSStringFromCGPoint(self.frame.origin),
            NSStringFromCGSize(self.frame.size)];
}

@end
