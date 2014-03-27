#import <UIKit/UIKit.h>

extern int const kWidth;
extern int const kHeight;

@interface DraggedTile: UIView

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *letter;
@property (weak, nonatomic) IBOutlet UILabel *value;

@end
