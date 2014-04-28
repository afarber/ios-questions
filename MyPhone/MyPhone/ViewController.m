#import "ViewController.h"
#import "ZoomViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString* const kAppleMaps = @"https://maps.apple.com/?q=%@";
static NSString* const kGoogleMaps = @"comgooglemaps-x-callback://?q=%@&x-success=myphone://?resume=true&x-source=MyPhone";
static NSString* const kAvatar = @"https://lh6.googleusercontent.com/-6Uce9r3S9D8/AAAAAAAAAAI/AAAAAAAAC5I/ZZo0yzCajig/photo.jpg";

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTitle:@"Google+"];
    
    _firstName.text = @"Alex";
    
    [_cityBtn setTitle:@"Bochum" forState:UIControlStateNormal];
    
    [_avatar setImageWithURL:[NSURL URLWithString:kAvatar]
               placeholderImage:[UIImage imageNamed:@"Male.png"]];
}

- (IBAction)avatarTapped:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    double delayInSeconds = .2;
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        [self performSegueWithIdentifier: @"pushZoom" sender: self];
    });
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"pushZoom"]){
        ZoomViewController *nextController = segue.destinationViewController;
        [nextController setTitle:@"Alex"];
        //[nextController.avatar setImageWithURL:[NSURL URLWithString:kAvatar]
          //                    placeholderImage:[UIImage imageNamed:@"Male.png"]];
        [nextController.avatar setImage:[UIImage imageNamed:@"Male.png"]];
    }
}

- (IBAction)cityPressed:(id)sender
{
    NSURL* testURL = [NSURL URLWithString:@"comgooglemaps-x-callback://"];
    NSString* fmt = ([[UIApplication sharedApplication] canOpenURL:testURL] ? kGoogleMaps : kAppleMaps);
    NSString* city = [self urlencode:_cityBtn.currentTitle];
    NSString* str = [NSString stringWithFormat:fmt, city];
    NSLog(@"%s: str=%@", __PRETTY_FUNCTION__, str);
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
