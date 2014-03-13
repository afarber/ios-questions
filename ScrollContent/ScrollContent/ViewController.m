#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _imageView.frame = CGRectMake(0, 0, 1000, 1000);
    _contentView.frame = CGRectMake(0, 0, 1000, 1000);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _scrollView.contentSize = CGSizeMake(1000, 1000);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
