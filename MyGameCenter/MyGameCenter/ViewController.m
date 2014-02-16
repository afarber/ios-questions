#import <GameKit/GameKit.h>
#import "ViewController.h"

static NSString* const kAvatar = @"http://afarber.de/gc/%@.jpg";
static NSString* const kScript = @"http://afarber.de/gc-upload.php";
static NSString* const kBody   = @"id=%@&img=%@";

@interface ViewController() {
    NSString* _playerId;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchUser];
}

- (void)fetchUser
{
    __weak GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
        
        assert([NSThread isMainThread]);

        if (viewController != nil) {
            [self presentViewController:viewController
                               animated:YES
                             completion:nil];
            
        } else if (localPlayer.isAuthenticated) {
            _aliasLabel.text = localPlayer.alias;
            _idLabel.text    = localPlayer.playerID;
            _playerId        = localPlayer.playerID;
            
            [self loadAvatar:localPlayer];
        } else {
            [self showAlert:@"Game Center has been disabled."];
        }
        
        if (error) {
            [self showAlert:error.description];
        }
    };
}

- (void)loadAvatar:(GKPlayer*)player
{
    [player loadPhotoForSize:GKPhotoSizeNormal withCompletionHandler:^(UIImage *photo, NSError *error) {
        if (error) {
            [self showAlert:error.description];
            //return;
        }
        
        if (photo) {
            _imageView.image = photo;
            [self uploadImage:photo];
        }
    }];
}

- (void)showAlert:(NSString*)msg {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"WARNING"
                                  message:msg
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    });
}

- (void)uploadImage:(UIImage*)img
{
    NSData* data = UIImageJPEGRepresentation(img, .75);
    NSString* str = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSLog(@"%s: img=%@ data=%@", __PRETTY_FUNCTION__, img, str);
    
    NSURL *url = [NSURL URLWithString:kScript];

    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setTimeoutInterval:30.0f];
    [req setHTTPMethod:@"POST"];

    NSString *body = [NSString stringWithFormat:kBody, _playerId, img];
    [req setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    [NSURLConnection sendAsynchronousRequest:req
                                       queue:queue
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               
        if ([data length] > 0 && error == nil) {
            NSString *html = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
            
            NSLog(@"HTML = %@", html);
        }
        else if ([data length] == 0 && error == nil) {
            NSLog(@"Nothing was downloaded.");
        }
        else if (error != nil) {
            NSLog(@"Error happened = %@", error);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
