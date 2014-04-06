#import "SmallTile.h"

int const kSmallTileWidth       = 45;
int const kSmallTileHeight      = 45;

static NSString* const kLetters = @"ABCDEFGHIJKLMNOPQRSTUWVXYZ";
static NSDictionary* letterValues;

@implementation SmallTile

+ (void)initialize
{
    if (self != [SmallTile class])
        return;
    
    letterValues = @{
         @"A": @1,
         @"B": @4,
         @"C": @4,
         @"D": @2,
         @"E": @1,
         @"F": @4,
         @"G": @3,
         @"H": @3,
         @"I": @1,
         @"J": @10,
         @"K": @5,
         @"L": @2,
         @"M": @4,
         @"N": @2,
         @"O": @1,
         @"P": @4,
         @"Q": @10,
         @"R": @1,
         @"S": @1,
         @"T": @1,
         @"U": @2,
         @"V": @5,
         @"W": @4,
         @"X": @8,
         @"Y": @3,
         @"Z": @10,
    };
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSString* randomLetter = [kLetters substringWithRange:[kLetters rangeOfComposedCharacterSequenceAtIndex:arc4random_uniform(kLetters.length)]];
    int letterValue = [letterValues[randomLetter] integerValue];
    
    _letter.text = randomLetter;
    _value.text = [NSString stringWithFormat:@"%d", letterValue];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"SmallTile %@ %@ %@ %@",
            _letter.text,
            _value.text,
            NSStringFromCGPoint(self.frame.origin),
            NSStringFromCGSize(self.frame.size)];
}

- (BigTile*)cloneTile
{
	BigTile *tile = [[[NSBundle mainBundle] loadNibNamed:@"BigTile"
												   owner:self
											     options:nil] firstObject];
	tile.letter.text = _letter.text;
    tile.value.text = _value.text;

	return tile;
}

- (void)snapToGrid
{
    _col = floorf((self.center.x - kBoardLeft) / kSmallTileWidth);
    _row = floorf((self.center.y - kBoardTop) / kSmallTileHeight);
    
    if (_col < 0) {
        _col = 0;
    } else if (_col > 14) {
        _col = 14;
    }
    
    if (_row < 0.0) {
        _row = 0.0;
    } else if (_row > 14.0) {
        _row = 14.0;
    }
    
    CGFloat x = kBoardLeft + (.5 + _col) * kSmallTileWidth;
    CGFloat y = kBoardTop  + (.5 + _row) * kSmallTileHeight;
        
    self.center = CGPointMake(x, y);
}

@end
