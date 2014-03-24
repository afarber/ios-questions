#import <UIKit/UIKit.h>

extern int const kTileWidth;
extern int const kTileHeight;

extern NSString* const kTileTouched;
extern NSString* const kTileReleased;
extern NSString* const kTileMoved;

@interface Tile : UIView

@property (assign, nonatomic) BOOL dragged;

@property (weak, nonatomic) IBOutlet UIImageView *bigImage;
@property (weak, nonatomic) IBOutlet UILabel *bigLetter;
@property (weak, nonatomic) IBOutlet UILabel *bigValue;

@property (weak, nonatomic) IBOutlet UIImageView *smallImage;
@property (weak, nonatomic) IBOutlet UILabel *smallLetter;
@property (weak, nonatomic) IBOutlet UILabel *smallValue;

- (Tile*)cloneTile;

@end
