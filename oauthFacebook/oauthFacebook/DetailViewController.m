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
	// Do any additional setup after loading the view.
    
    NSLog(@"id: %@", _dict[@"id"]);
    NSLog(@"first_name: %@", _dict[@"first_name"]);
    NSLog(@"last_name: %@", _dict[@"last_name"]);
    NSLog(@"gender: %@", _dict[@"gender"]);
    NSLog(@"city: %@", _dict[@"location"][@"name"]);
    
    NSString *avatar = [NSString stringWithFormat:kAvatar, _dict[@"id"]];
    NSLog(@"avatar: %@", avatar);
    
    _userId.text    = _dict[@"id"];
    _firstName.text = _dict[@"first_name"];
    _lastName.text  = _dict[@"last_name"];
    _gender.text    = _dict[@"gender"];
    _city.text      = _dict[@"location"][@"name"];
    
    [_imageView setImageWithURL:[NSURL URLWithString:avatar]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
