#import "Tile.h"

static NSString* const kLetters =  @"ABCDEFGHIJKLMNOPQRSTUWVXYZ";

@implementation Tile

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSString* randomLetter = [kLetters substringWithRange:[kLetters rangeOfComposedCharacterSequenceAtIndex:random()%[kLetters length]]];
    int randomInteger = 1 + (int)arc4random_uniform(9);
    NSLog(@"%s: randomLetter=%@, randomInteger=%d", __PRETTY_FUNCTION__, randomLetter, randomInteger);
    
    _smallLetter.text = _bigLetter.text = randomLetter;
    _smallValue.text = _bigValue.text = [NSString stringWithFormat:@"%d", randomInteger];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
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
    NSLog(@"%s", __PRETTY_FUNCTION__);

    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGPoint previous = [touch previousLocationInView:self];
    self.frame = CGRectOffset(self.frame,
                              (location.x - previous.x),
                              (location.y - previous.y));
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    [_smallImage setHidden:NO];
    [_smallLetter setHidden:NO];
    [_smallValue setHidden:NO];
    
    [_bigImage setHidden:YES];
    [_bigLetter setHidden:YES];
    [_bigValue setHidden:YES];
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    [_smallImage setHidden:NO];
    [_smallLetter setHidden:NO];
    [_smallValue setHidden:NO];
    
    [_bigImage setHidden:YES];
    [_bigLetter setHidden:YES];
    [_bigValue setHidden:YES];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@ %@",
            self.smallLetter.text,
            self.smallValue.text];
}

@end
