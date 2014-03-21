#import "Tile.h"

int const kTileWidth            = 45;
int const kTileHeight           = 45;
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
    
    _smallLetter.text = _bigLetter.text = randomLetter;
    _smallValue.text = _bigValue.text = [NSString stringWithFormat:@"%d", letterValue];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    //NSLog(@"%s: tile=%@", __PRETTY_FUNCTION__, self);
    
    [_smallImage setHidden:YES];
    [_smallLetter setHidden:YES];
    [_smallValue setHidden:YES];
    
    [_bigImage setHidden:NO];
    [_bigLetter setHidden:NO];
    [_bigValue setHidden:NO];

    [self.superview bringSubviewToFront:self];
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    //NSLog(@"%s: tile=%@", __PRETTY_FUNCTION__, self);

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
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    //NSLog(@"%s: tile=%@", __PRETTY_FUNCTION__, self);

    [_smallImage setHidden:NO];
    [_smallLetter setHidden:NO];
    [_smallValue setHidden:NO];
    
    [_bigImage setHidden:YES];
    [_bigLetter setHidden:YES];
    [_bigValue setHidden:YES];
    
    NSNotification *notification = [NSNotification
                                    notificationWithName:kTileMoved
                                    object:self
                                    userInfo:@{@"Key 1" : @"Value 1",
                                               @"Key 2" : @2}];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotification:notification];
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
{
    //NSLog(@"%s: tile=%@", __PRETTY_FUNCTION__, self);

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
    return [NSString stringWithFormat:@"%@ %@ %@ %@",
            self.smallLetter.text,
            self.smallValue.text,
            NSStringFromCGPoint(self.frame.origin),
            NSStringFromCGSize(self.frame.size)];
}

@end
