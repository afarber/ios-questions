#import "Tile.h"

static NSString* const kLetters =  @"ABCDEFGHIJKLMNOPQRSTUWVXYZ";
static UIImage* kTile;
static UIImage* kDragged;

@implementation Tile

+ (void)initialize
{
    // do not run for derived classes
    if (self != [Tile class])
        return;
    
    kTile    = [UIImage imageNamed:@"tile"];
    kDragged = [UIImage imageNamed:@"dragged"];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSString* randomLetter = [kLetters substringWithRange:[kLetters rangeOfComposedCharacterSequenceAtIndex:random()%[kLetters length]]];
    int randomInteger = 1 + (int)arc4random_uniform(9);
    NSLog(@"%s: randomLetter=%@, randomInteger=%d", __PRETTY_FUNCTION__, randomLetter, randomInteger);
    
    _background.image = kTile;
    _letter.text = randomLetter;
    _value.text = [NSString stringWithFormat:@"%d", randomInteger];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString* randomLetter = [kLetters substringWithRange:[kLetters rangeOfComposedCharacterSequenceAtIndex:random()%[kLetters length]]];
        int randomInteger = (int)arc4random_uniform(10);
        
        NSLog(@"%s: randomLetter=%@, randomInteger=%d",
              __PRETTY_FUNCTION__,
              randomLetter,
              randomInteger);
        
        _background.image = kTile;
        _letter.text = randomLetter;
        _value.text = [NSString stringWithFormat:@"%d", randomInteger];
    }
    return self;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    _background.image = kDragged;
    [_letter setFont:[UIFont systemFontOfSize:48]];
    [_value setFont:[UIFont systemFontOfSize:20]];

    [self.superview bringSubviewToFront:self];

    [super touchesBegan:touches withEvent:event];
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
    _background.image = kTile;
    [_letter setFont:[UIFont systemFontOfSize:36]];
    [_value setFont:[UIFont systemFontOfSize:16]];
    
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
{
    _background.image = kTile;
    [_letter setFont:[UIFont systemFontOfSize:36]];
    [_value setFont:[UIFont systemFontOfSize:16]];
    
    [super touchesCancelled:touches withEvent:event];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@ %@",
            self.letter.text,
            self.value.text];
}

@end
