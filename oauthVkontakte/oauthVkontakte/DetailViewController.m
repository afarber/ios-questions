#import "DetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

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
    
    NSLog(@"id: %@", _dict[@"uid"]);
    NSLog(@"first_name: %@", _dict[@"first_name"]);
    NSLog(@"last_name: %@", _dict[@"last_name"]);
    NSLog(@"city: %@", _dict[@"city"]);

    NSString *gender = (2 == (long)_dict[@"sex"] ? @"male" : @"female");
    NSLog(@"gender: %@", gender);
    
    NSString *avatar = _dict[@"photo_big"];
    NSLog(@"avatar: %@", avatar);
    
    _userId.text    = [NSString stringWithFormat:@"%@", _dict[@"uid"]];
    _firstName.text = _dict[@"first_name"];
    _lastName.text  = _dict[@"last_name"];
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
