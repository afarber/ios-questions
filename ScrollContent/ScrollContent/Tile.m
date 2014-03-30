#import "Tile.h"

int const kTileWidth            = 45;
int const kTileHeight           = 45;

static NSString* const kLetters = @"ABCDEFGHIJKLMNOPQRSTUWVXYZ";
static NSDictionary* letterValues;

@implementation Tile

+ (void)initialize
{
    if (self != [Tile class])
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
    return [NSString stringWithFormat:@"Tile %@ %@ %@ %@",
            _letter.text,
            _value.text,
            NSStringFromCGPoint(self.frame.origin),
            NSStringFromCGSize(self.frame.size)];
}

- (DraggedTile*)cloneTile
{
	DraggedTile *tile = [[[NSBundle mainBundle] loadNibNamed:@"DraggedTile"
												owner:self
											  options:nil] firstObject];
	tile.exclusiveTouch = YES;
	
	tile.letter.text = _letter.text;
    tile.value.text = _value.text;

	return tile;
}

@end
