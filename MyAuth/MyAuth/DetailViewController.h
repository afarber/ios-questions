#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) NSDictionary *dict;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
