#import "ViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <TSMessages/TSMessage.h>

static NSString* const kAvatar = @"http://gravatar.com/avatar/55b3816622d935e50098bb44c17663bc.png";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_imageView setImageWithURL:[NSURL URLWithString:kAvatar]
               placeholderImage:[UIImage imageNamed:@"male.png"]];
    
    [TSMessage showNotificationInViewController:self
                                          title:@"I love CocoaPods"
                                       subtitle:@"It is so easy..."
                                           type:TSMessageNotificationTypeSuccess];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
