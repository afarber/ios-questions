#import <UIKit/UIKit.h>

@interface Tile : UIView

@property (assign, nonatomic) BOOL dragged;
@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UILabel *letter;
@property (weak, nonatomic) IBOutlet UILabel *value;

@end
