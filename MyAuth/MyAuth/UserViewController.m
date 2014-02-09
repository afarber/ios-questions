#import "UserViewController.h"
#import "SocialNetwork.h"
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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    User *user = [User load];
    if (user) {
        _userId.text    = [NSString stringWithFormat:@"%@", user.userId];
        _firstName.text = user.firstName;
        _lastName.text  = user.lastName;
        _city.text      = user.city;
        _gender.text    = (user.female ? @"female" : @"male");
        
        NSString *placeHolder = (user.female ? @"female.png" : @"male.png");
        
        [_imageView setImageWithURL:[NSURL URLWithString:user.avatar]
                   placeholderImage:[UIImage imageNamed:placeHolder]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(logout:)];

    self.navigationItem.rightBarButtonItem = logoutButton;
}

- (IBAction)logout:(id)sender
{
    [User reset];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
