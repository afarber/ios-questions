#import "ViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString* const kMaps = @"https://maps.google.com/?q=%@";
static NSString* const kAvatar = @"https://lh6.googleusercontent.com/-6Uce9r3S9D8/AAAAAAAAAAI/AAAAAAAAC5I/ZZo0yzCajig/photo.jpg";

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTitle:@"Google+"];
    
    _firstName.text = @"Alex";
    
    [_cityBtn setTitle:@"Bochum" forState:UIControlStateNormal];
    
    [_imageView setImageWithURL:[NSURL URLWithString:kAvatar]
               placeholderImage:[UIImage imageNamed:@"Male.png"]];
}

- (IBAction)cityPressed:(id)sender
{
    NSString* str = [NSString stringWithFormat:kMaps, [self urlencode:_cityBtn.currentTitle]];
    NSLog(@"%s: url=%@", __PRETTY_FUNCTION__, str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (NSString*)urlencode:(NSString*)str
{
    return (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
        NULL,
        (__bridge CFStringRef) str,
        NULL,
        CFSTR(":/?@!$&'()*+,;="),
        kCFStringEncodingUTF8));
}

@end
