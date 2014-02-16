#import <GameKit/GameKit.h>
#import "ViewController.h"

static NSString* const kAvatar = @"http://afarber.de/gc/%@.png";

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchMe];
}

- (void) fetchMe
{
    __weak GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
        assert([NSThread isMainThread]);

        if (viewController != nil) {
            [self presentViewController:viewController
                               animated:YES
                             completion:nil];
        } else if (localPlayer.isAuthenticated) {
            NSLog(@"isAuthenticated %@ %@",
                  [localPlayer alias],
                  [localPlayer playerID]);
            
            _idLabel.text = localPlayer.playerID;
            _aliasLabel.text = localPlayer.alias;
            
            [self loadAvatar:localPlayer];
            
        } else {
            [self showAlert:@"Game Center has been disabled."];
        }
        
        NSLog(@"%s: error=%@", __PRETTY_FUNCTION__, error);
    };
}

- (void)loadAvatar:(GKPlayer*)player
{
    [player loadPhotoForSize:GKPhotoSizeNormal withCompletionHandler:^(UIImage *photo, NSError *error) {
        if (error != nil) {
            NSLog(@"%s: error=%@", __PRETTY_FUNCTION__, error);
            return;
        }
        
        if (photo != nil) {
            _imageView.image = photo;
            
            NSData* data = UIImageJPEGRepresentation(photo, .75);
            // [NSData base64EncodedDataWithOptions:]
            NSLog(@"%s: photo=%@ data=%@", __PRETTY_FUNCTION__, photo, data);
        }
    }];
}

- (void) showAlert:(NSString*) msg {    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
