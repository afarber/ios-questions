#import <UIKit/UIKit.h>

@interface Tile : UIView

@property (weak, nonatomic) IBOutlet UIImageView *bigImage;
@property (weak, nonatomic) IBOutlet UILabel *bigLetter;
@property (weak, nonatomic) IBOutlet UILabel *bigValue;

@property (weak, nonatomic) IBOutlet UIImageView *smallImage;
@property (weak, nonatomic) IBOutlet UILabel *smallLetter;
@property (weak, nonatomic) IBOutlet UILabel *smallValue;

@end
