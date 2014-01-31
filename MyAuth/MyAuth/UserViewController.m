#import "UserViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface UserViewController ()

@end

@implementation UserViewController

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
    
    NSLog(@"id: %@",         _user.userId);
    NSLog(@"first_name: %@", _user.firstName);
    NSLog(@"last_name: %@",  _user.lastName);
    NSLog(@"city: %@",       _user.city);
    NSLog(@"female: %hhd",   _user.female);
    NSLog(@"avatar: %@",     _user.avatar);
    
    _userId.text    = [NSString stringWithFormat:@"%@", _user.userId];
    _firstName.text = _user.firstName;
    _lastName.text  = _user.lastName;
    _city.text      = _user.city;
    _gender.text    = (_user.female ? @"female" : @"male");
    
    NSString *placeHolder = (_user.female ? @"female.png" : @"male.png");
    
    [_imageView setImageWithURL:[NSURL URLWithString:_user.avatar]
               placeholderImage:[UIImage imageNamed:placeHolder]];
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(logout:)];

    self.navigationItem.rightBarButtonItem = logoutButton;
}

- (IBAction)logout:(id)sender
{
    // TODO: add logout code for social network selected
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
