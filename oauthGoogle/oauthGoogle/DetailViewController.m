#import "DetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString* const kAvatar =   @"http://graph.facebook.com/%@/picture?type=large";

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"id: %@", _dict[@"id"]);
    NSLog(@"first_name: %@", _dict[@"first_name"]);
    NSLog(@"last_name: %@", _dict[@"last_name"]);
    NSLog(@"city: %@", _dict[@"location"][@"name"]);

    NSString *gender = _dict[@"gender"];
    NSLog(@"gender: %@", gender);
    
    NSString *avatar = [NSString stringWithFormat:kAvatar, _dict[@"id"]];
    NSLog(@"avatar: %@", avatar);
    
    _userId.text    = _dict[@"id"];
    _firstName.text = _dict[@"first_name"];
    _lastName.text  = _dict[@"last_name"];
    _city.text      = _dict[@"location"][@"name"];
    _gender.text    = gender;
    
    NSString *placeHolder = (gender != nil &&
                             [gender caseInsensitiveCompare:@"male"] == NSOrderedSame ?
                             @"male.png" : @"female.png");
    
    [_imageView setImageWithURL:[NSURL URLWithString:avatar]
               placeholderImage:[UIImage imageNamed:placeHolder]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
