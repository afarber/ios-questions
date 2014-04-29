#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>

@interface ZoomViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@property (strong, nonatomic) NSURL *url;

@end
