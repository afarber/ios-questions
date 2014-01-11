#import "ViewController.h"

static NSString* const kAvatar = @"http://gravatar.com/avatar/55b3816622d935e50098bb44c17663bc.png";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _imageView.image = [UIImage imageNamed:@"male.png"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
