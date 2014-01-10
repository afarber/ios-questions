#import "DetailViewController.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDict:(NSDictionary *)dict
{
    NSLog(@"id: %@", dict[@"id"]);
    NSLog(@"first_name: %@", dict[@"first_name"]);
    NSLog(@"last_name: %@", dict[@"last_name"]);
    NSLog(@"gender: %@", dict[@"gender"]);
    NSLog(@"city: %@", dict[@"location"][@"name"]);
    
    NSString *avatar = [NSString stringWithFormat:kAvatar, dict[@"id"]];
    NSLog(@"avatar: %@", avatar);
    
    [[self userId] setText:dict[@"id"]];
    [_firstName setText:dict[@"first_name"]];
    [_lastName setText:dict[@"last_name"]];
    [_gender setText:dict[@"gender"]];
    [_city setText:dict[@"location"][@"name"]];
}

@end
