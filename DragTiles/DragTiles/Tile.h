#import <UIKit/UIKit.h>

@interface Tile : UIView

@property (weak, nonatomic) IBOutlet UIImageView *dragged;
@property (weak, nonatomic) IBOutlet UIImageView *normal;
@property (weak, nonatomic) IBOutlet UILabel *letter;
@property (weak, nonatomic) IBOutlet UILabel *value;

@end
