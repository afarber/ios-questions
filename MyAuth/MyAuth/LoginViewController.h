#import <UIKit/UIKit.h>
#import "SocialNetwork.h"

@interface LoginViewController : UIViewController <UIWebViewDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) id<SocialNetwork> sn;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
