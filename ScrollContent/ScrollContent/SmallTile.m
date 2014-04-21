#import "SmallTile.h"

int const kSmallTileWidth       = 45;
int const kSmallTileHeight      = 45;

static NSString* const kLetters = @"ABCDEFGHIJKLMNOPQRSTUWVXYZ";
static NSDictionary* letterValues;
static NSMutableArray* grid;
static NSArray* spiral;

static UIImage *IMG_NW;
static UIImage *IMG_N;
static UIImage *IMG_NE;
static UIImage *IMG_W;
static UIImage *IMG_M;
static UIImage *IMG_E;
static UIImage *IMG_SW;
static UIImage *IMG_S;
static UIImage *IMG_SE;

static UIImage *IMG_NE12;
static UIImage *IMG_NE13;
static UIImage *IMG_NE23;
static UIImage *IMG_NW12;
static UIImage *IMG_NW13;
static UIImage *IMG_NW23;
static UIImage *IMG_SE12;
static UIImage *IMG_SE13;
static UIImage *IMG_SE23;
static UIImage *IMG_SW12;
static UIImage *IMG_SW13;
static UIImage *IMG_SW23;

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
    
    IMG_NW = [UIImage imageNamed:@"nw.png"];
    IMG_N  = [UIImage imageNamed:@"n.png"];
    IMG_NE = [UIImage imageNamed:@"ne.png"];
    IMG_W  = [UIImage imageNamed:@"w.png"];
    IMG_M  = [UIImage imageNamed:@"m.png"];
    IMG_E  = [UIImage imageNamed:@"e.png"];
    IMG_SW = [UIImage imageNamed:@"sw.png"];
    IMG_S  = [UIImage imageNamed:@"s.png"];
    IMG_SE = [UIImage imageNamed:@"se.png"];
    
    IMG_NE12 = [UIImage imageNamed:@"ne12.png"];
    IMG_NE13 = [UIImage imageNamed:@"ne13.png"];
    IMG_NE23 = [UIImage imageNamed:@"ne23.png"];
    IMG_NW12 = [UIImage imageNamed:@"nw12.png"];
    IMG_NW13 = [UIImage imageNamed:@"nw13.png"];
    IMG_NW23 = [UIImage imageNamed:@"nw23.png"];
    IMG_SE12 = [UIImage imageNamed:@"se12.png"];
    IMG_SE13 = [UIImage imageNamed:@"se13.png"];
    IMG_SE23 = [UIImage imageNamed:@"se23.png"];
    IMG_SW12 = [UIImage imageNamed:@"sw12.png"];
    IMG_SW13 = [UIImage imageNamed:@"sw13.png"];
    IMG_SW23 = [UIImage imageNamed:@"sw23.png"];
    
    spiral = @[
               @[@0, @0],
               @[@1, @0],
               @[@0, @1],
               @[@-1, @0],
               @[@0, @-1],
               @[@1, @1],
               @[@-1, @1],
               @[@-1, @-1],
               @[@1, @-1],
    ];
    
    grid = [[NSMutableArray alloc] init];
    for (int i = 0; i < 15; i++) {
        NSMutableArray *row = [[NSMutableArray alloc] init];
        for (int j = 0; j < 15; j++) {
            [row addObject:[NSNull null]];
        }
        [grid addObject:row];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSString* randomLetter = [kLetters substringWithRange:
                              [kLetters rangeOfComposedCharacterSequenceAtIndex:arc4random_uniform(kLetters.length)]];
    int letterValue = [letterValues[randomLetter] integerValue];
    _letter.text = randomLetter;
    _value.text = [NSString stringWithFormat:@"%d", letterValue];
    _col = -1;
    _row = -1;
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

- (NSInteger)limit:(NSInteger)n
{
    if (n < 0)
        return 0;
    if (n > 14)
        return 14;
    return n;
}

- (BOOL)addToGrid
{
    NSInteger i = floorf((self.center.x - kBoardLeft) / kSmallTileWidth);
    NSInteger j = floorf((self.center.y - kBoardTop) / kSmallTileHeight);
    
    for (NSArray* arr in spiral) {
        NSInteger col = [self limit:i + [arr[0] integerValue]];
        NSInteger row = [self limit:j + [arr[1] integerValue]];
        
        // if found a free cell
        if (grid[col][row] == [NSNull null]) {
            _col = col;
            _row = row;
            grid[_col][_row] = self;
            
            CGFloat x = kBoardLeft + (.5 + _col) * kSmallTileWidth;
            CGFloat y = kBoardTop  + (.5 + _row) * kSmallTileHeight;
            self.center = CGPointMake(x, y);
            
            [self adaptTile];
            
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)occupiedCol:(NSInteger)i Row:(NSInteger)j
{
    if (i < 0 ||
        i > 14 ||
        j < 0 ||
        j > 14)
        return NO;
    
    return grid[i][j] != [NSNull null];
}

- (void)adaptTile
{
    if (_col == -1 || _row == -1) {
        _image.hidden = NO;
        
        _imgNW.hidden = YES;
        _imgN.hidden  = YES;
        _imgNE.hidden = YES;
        _imgW.hidden  = YES;
        _imgM.hidden  = YES;
        _imgE.hidden  = YES;
        _imgSW.hidden = YES;
        _imgS.hidden  = YES;
        _imgSE.hidden = YES;
        
        return;
    }
    
    _image.hidden = YES;
    
    _imgNW.hidden = NO;
    _imgN.hidden  = NO;
    _imgNE.hidden = NO;
    _imgW.hidden  = NO;
    _imgM.hidden  = NO;
    _imgE.hidden  = NO;
    _imgSW.hidden = NO;
    _imgS.hidden  = NO;
    _imgSE.hidden = NO;
    
    _imgW.image = [self occupiedCol:_col - 1 Row:_row] ? IMG_M : IMG_W;
    _imgE.image = [self occupiedCol:_col + 1 Row:_row] ? IMG_M : IMG_E;
    _imgN.image = [self occupiedCol:_col Row:_row - 1] ? IMG_M : IMG_N;
    _imgS.image = [self occupiedCol:_col Row:_row + 1] ? IMG_M : IMG_S;
    
    if ([self occupiedCol:_col - 1 Row:_row] &&
        [self occupiedCol:_col - 1 Row:_row - 1] &&
        [self occupiedCol:_col Row:_row - 1]) {
        _imgNW.image = IMG_M;
    } else if (![self occupiedCol:_col - 1 Row:_row] &&
               ![self occupiedCol:_col - 1 Row:_row - 1] &&
               [self occupiedCol:_col Row:_row - 1]) {
        _imgNW.image = IMG_W;
    } else if ([self occupiedCol:_col - 1 Row:_row] &&
               ![self occupiedCol:_col - 1 Row:_row - 1] &&
               ![self occupiedCol:_col Row:_row - 1]) {
        _imgNW.image = IMG_N;
    } else if ([self occupiedCol:_col - 1 Row:_row] &&
               ![self occupiedCol:_col - 1 Row:_row - 1] &&
               [self occupiedCol:_col Row:_row - 1]) {
        _imgNW.image = IMG_NW13;
    } else if ([self occupiedCol:_col - 1 Row:_row] &&
               [self occupiedCol:_col - 1 Row:_row - 1] &&
               ![self occupiedCol:_col Row:_row - 1]) {
        _imgNW.image = IMG_NW12;
    } else if (![self occupiedCol:_col - 1 Row:_row] &&
               [self occupiedCol:_col - 1 Row:_row - 1] &&
               [self occupiedCol:_col Row:_row - 1]) {
        _imgNW.image = IMG_NW23;
    } else {
        _imgNW.image = IMG_NW;
    }
    
    if ([self occupiedCol:_col + 1 Row:_row] &&
        [self occupiedCol:_col + 1 Row:_row - 1] &&
        [self occupiedCol:_col Row:_row - 1]) {
        _imgNE.image = IMG_M;
    } else if (![self occupiedCol:_col + 1 Row:_row] &&
               ![self occupiedCol:_col + 1 Row:_row - 1] &&
               [self occupiedCol:_col Row:_row - 1]) {
        _imgNE.image = IMG_E;
    } else if ([self occupiedCol:_col + 1 Row:_row] &&
               ![self occupiedCol:_col + 1 Row:_row - 1] &&
               ![self occupiedCol:_col Row:_row - 1]) {
        _imgNE.image = IMG_N;
    } else if ([self occupiedCol:_col + 1 Row:_row] &&
               ![self occupiedCol:_col + 1 Row:_row - 1] &&
               [self occupiedCol:_col Row:_row - 1]) {
        _imgNE.image = IMG_NE13;
    } else if (![self occupiedCol:_col + 1 Row:_row] &&
               [self occupiedCol:_col + 1 Row:_row - 1] &&
               [self occupiedCol:_col Row:_row - 1]) {
        _imgNE.image = IMG_NE12;
    } else if ([self occupiedCol:_col + 1 Row:_row] &&
               [self occupiedCol:_col + 1 Row:_row - 1] &&
               ![self occupiedCol:_col Row:_row - 1]) {
        _imgNE.image = IMG_NE23;
    } else {
        _imgNE.image = IMG_NE;
    }
    
    if ([self occupiedCol:_col - 1 Row:_row] &&
        [self occupiedCol:_col - 1 Row:_row + 1] &&
        [self occupiedCol:_col Row:_row + 1]) {
        _imgSW.image = IMG_M;
    } else if (![self occupiedCol:_col - 1 Row:_row] &&
               ![self occupiedCol:_col - 1 Row:_row + 1] &&
               [self occupiedCol:_col Row:_row + 1]) {
        _imgSW.image = IMG_W;
    } else if ([self occupiedCol:_col - 1 Row:_row] &&
               ![self occupiedCol:_col - 1 Row:_row + 1] &&
               ![self occupiedCol:_col Row:_row + 1]) {
        _imgSW.image = IMG_S;
    } else if ([self occupiedCol:_col - 1 Row:_row] &&
               ![self occupiedCol:_col - 1 Row:_row + 1] &&
               [self occupiedCol:_col Row:_row + 1]) {
        _imgSW.image = IMG_SW13;
    } else if (![self occupiedCol:_col - 1 Row:_row] &&
               [self occupiedCol:_col - 1 Row:_row + 1] &&
               [self occupiedCol:_col Row:_row + 1]) {
        _imgSW.image = IMG_SW12;
    } else if ([self occupiedCol:_col - 1 Row:_row] &&
               [self occupiedCol:_col - 1 Row:_row + 1] &&
               ![self occupiedCol:_col Row:_row + 1]) {
        _imgSW.image = IMG_SW23;
    } else {
        _imgSW.image = IMG_SW;
    }
    
    if ([self occupiedCol:_col + 1 Row:_row] &&
        [self occupiedCol:_col + 1 Row:_row + 1] &&
        [self occupiedCol:_col Row:_row + 1]) {
        _imgSE.image = IMG_M;
    } else if (![self occupiedCol:_col + 1 Row:_row] &&
               ![self occupiedCol:_col + 1 Row:_row + 1] &&
               [self occupiedCol:_col Row:_row + 1]) {
        _imgSE.image = IMG_E;
    } else if ([self occupiedCol:_col + 1 Row:_row] &&
               ![self occupiedCol:_col + 1 Row:_row + 1] &&
               ![self occupiedCol:_col Row:_row + 1]) {
        _imgSE.image = IMG_S;
    } else if ([self occupiedCol:_col + 1 Row:_row] &&
               ![self occupiedCol:_col + 1 Row:_row + 1] &&
               [self occupiedCol:_col Row:_row + 1]) {
        _imgSE.image = IMG_SE13;
    } else if ([self occupiedCol:_col + 1 Row:_row] &&
               [self occupiedCol:_col + 1 Row:_row + 1] &&
               ![self occupiedCol:_col Row:_row + 1]) {
        _imgSE.image = IMG_SE12;
    } else if (![self occupiedCol:_col + 1 Row:_row] &&
               [self occupiedCol:_col + 1 Row:_row + 1] &&
               [self occupiedCol:_col Row:_row + 1]) {
        _imgSE.image = IMG_SE23;
    } else {
        _imgSE.image = IMG_SE;
    }
}

- (void)removeFromGrid
{
    if (_col >= 0 &&
        _col <= 14 &&
        _row >= 0 &&
        _row <= 14) {
        grid[_col][_row] = [NSNull null];
    }
    
    _col = -1;
    _row = -1;
}

@end
