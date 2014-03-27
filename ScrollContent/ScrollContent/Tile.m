#import "Tile.h"

int const kTileWidth            = 45;
int const kTileHeight           = 45;

NSString* const kTileTouched    = @"TILE_TOUCHED";
NSString* const kTileReleased   = @"TILE_RELEASED";
NSString* const kTileMoved      = @"TILE_MOVED";

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

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, self);
    
    [self postNotification:kTileTouched userInfo:nil];
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, self);

    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGPoint previous = [touch previousLocationInView:self];
    
    if (!CGAffineTransformIsIdentity(self.transform)) {
        location = CGPointApplyAffineTransform(location, self.transform);
        previous = CGPointApplyAffineTransform(previous, self.transform);
    }
    
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
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, self);

	UITouch *touch = [touches anyObject];
	
	[self postNotification:kTileReleased userInfo:@{@"touch": touch}];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"Tile %@ %@ %@ %@",
            _letter.text,
            _value.text,
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
