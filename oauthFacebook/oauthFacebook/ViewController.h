#import <UIKit/UIKit.h>
#import "SocialNetwork.h"

@interface ViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) id<SocialNetwork> sn;

@end
