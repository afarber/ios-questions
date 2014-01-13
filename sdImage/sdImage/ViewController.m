#import "ViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString* const kAvatar = @"http://gravatar.com/avatar/55b3816622d935e50098bb44c17663bc.png";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_imageView setImageWithURL:[NSURL URLWithString:kAvatar]
               placeholderImage:[UIImage imageNamed:@"male.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
