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
    NSLog(@"first_name: %@", _dict[@"given_name"]);
    NSLog(@"last_name: %@", _dict[@"family_name"]);
    NSLog(@"city: %@", _dict[@"city"]);

    NSString *gender = _dict[@"gender"];
    NSLog(@"gender: %@", gender);
    
    NSString *avatar = _dict[@"picture"];
    NSLog(@"avatar: %@", avatar);
    
    _userId.text    = _dict[@"id"];
    _firstName.text = _dict[@"given_name"];
    _lastName.text  = _dict[@"family_name"];
    _city.text      = _dict[@"city"];
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
