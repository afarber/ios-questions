#import "Tile.h"
#import "GameBoard.h"

int const kTileWidth            = 45;
int const kTileHeight           = 45;

NSString* const kTileTouched    = @"TILE_TOUCHED";
NSString* const kTileReleased   = @"TILE_RELEASED";
NSString* const kTileMoved   = @"TILE_MOVED";

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
    
    _smallLetter.text = _bigLetter.text = randomLetter;
    _smallValue.text = _bigValue.text = [NSString stringWithFormat:@"%d", letterValue];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, self);
    
    [_smallImage setHidden:YES];
    [_smallLetter setHidden:YES];
    [_smallValue setHidden:YES];
    
    [_bigImage setHidden:NO];
    [_bigLetter setHidden:NO];
    [_bigValue setHidden:NO];
    
    [self postNotification:kTileTouched userInfo:nil];
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, self);

    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGPoint previous = [touch previousLocationInView:self];
    
    self.frame = CGRectOffset(self.frame,
                              (location.x - previous.x),
                              (location.y - previous.y));
	
	[self postNotification:kTileMoved userInfo:@{@"touch": touch}];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, self);

	UITouch *touch = [touches anyObject];
	
	[self postNotification:kTileReleased userInfo:@{@"touch": touch}];
	
    [_smallImage setHidden:NO];
    [_smallLetter setHidden:NO];
    [_smallValue setHidden:NO];
    
    [_bigImage setHidden:YES];
    [_bigLetter setHidden:YES];
    [_bigValue setHidden:YES];
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, self);

	UITouch *touch = [touches anyObject];
	
	[self postNotification:kTileReleased userInfo:@{@"touch": touch}];
	
    [_smallImage setHidden:NO];
    [_smallLetter setHidden:NO];
    [_smallValue setHidden:NO];
    
    [_bigImage setHidden:YES];
    [_bigLetter setHidden:YES];
    [_bigValue setHidden:YES];
}

- (BOOL) dragged
{
    return _smallImage.hidden;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"Tile %@ %@ %@ %@",
            self.smallLetter.text,
            self.smallValue.text,
            NSStringFromCGPoint(self.frame.origin),
            NSStringFromCGSize(self.frame.size)];
}

- (void) postNotification:(NSString*)str userInfo:(NSDictionary*)userInfo
{
    NSAssert([str isEqualToString:kTileTouched] ||
             [str isEqualToString:kTileReleased] ||
			 [str isEqualToString:kTileMoved],
             @"Wrong argument for %s",
             __PRETTY_FUNCTION__);
    
    NSNotification *notification = [NSNotification
                                    notificationWithName:str
                                    object:self
                                    userInfo:userInfo];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotification:notification];
}

- (Tile*)cloneTile
{
	Tile *tile = [[[NSBundle mainBundle] loadNibNamed:@"Tile"
												owner:self
											  options:nil] firstObject];
	tile.exclusiveTouch = YES;
	
	tile.smallLetter.text = tile.bigLetter.text = _bigLetter.text;
    tile.smallValue.text = tile.bigValue.text = _bigValue.text;

	return tile;
}

@end
