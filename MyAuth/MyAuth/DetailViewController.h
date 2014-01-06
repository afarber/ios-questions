#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSDictionary *dict;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (void)setDetailItem:(NSDictionary*)newDict;

@end
