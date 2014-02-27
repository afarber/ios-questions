#import <GameKit/GameKit.h>
#import "GameCenterViewController.h"
#import "SocialNetwork.h"

static NSString* const kAvatar = @"http://afarber.de/gc/%@.jpg";
static NSString* const kScript = @"http://afarber.de/gc-upload.php";
static NSString* const kBody   = @"id=%@&img=%@";

@interface GameCenterViewController () {
    User* _user;
}
@end

@implementation GameCenterViewController

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
    
    [self fetchUser];
}

- (void)fetchUser
{
    __weak GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
        if (viewController != nil) {
            [self presentViewController:viewController
                               animated:YES
                             completion:nil];
            
        } else if (localPlayer.isAuthenticated) {
            NSLog(@"%s: alias=%@ playerID=%@", __PRETTY_FUNCTION__,
                  [localPlayer alias],
                  [localPlayer playerID]);
            
            _user = [[User alloc] init];
            _user.key       = kGC;
            _user.userId    = [localPlayer playerID];
            _user.firstName = [localPlayer alias];
            _user.avatar    = [NSString stringWithFormat:kAvatar, [self urlencode:_user.userId]];
            [_user save];

            [self loadAvatar:localPlayer];
            
            double delayInSeconds = 1;
            dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(delay, dispatch_get_main_queue(), ^(void){
                [self performSegueWithIdentifier: @"replaceGameCenter" sender: self];
            });
        } else {
            [self showAlert:@"Game Center has been disabled."];
        }
        
        NSLog(@"%s: error=%@", __PRETTY_FUNCTION__, error);
    };
}

- (void)loadAvatar:(GKPlayer*)player
{
    [player loadPhotoForSize:GKPhotoSizeNormal
       withCompletionHandler:^(UIImage *photo, NSError *error) {
        if (error) {
            [self showAlert:error.description];
            //return;
        }
        
        if (photo) {
            [self uploadImage:photo];
        }
    }];
}

- (void)uploadImage:(UIImage*)img
{
    NSData* data = UIImageJPEGRepresentation(img, .8);
    NSString* str = [data base64EncodedStringWithOptions:0];
    //NSLog(@"%s: img=%@ data=%@", __PRETTY_FUNCTION__, img, str);
    
    NSURL *url = [NSURL URLWithString:kScript];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setTimeoutInterval:30.0f];
    [req setHTTPMethod:@"POST"];
    
    NSString *body = [NSString stringWithFormat:kBody,
                      [self urlencode:_user.userId],
                      [self urlencode:str]];
    [req setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:queue
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               
       if ([data length] > 0 && error == nil) {
           id json = [NSJSONSerialization JSONObjectWithData:data
                                                     options:NSJSONReadingMutableContainers
                                                       error:nil];
           NSLog(@"JSON = %@", json);
       }
       else if ([data length] == 0 && error == nil) {
           NSLog(@"Nothing was downloaded.");
       }
       else if (error != nil) {
           NSLog(@"Error happened = %@", error);
       }
   }];
}

- (NSString*)urlencode:(NSString*)str
{
    return (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
        NULL,
        (__bridge CFStringRef) str,
        NULL,
        CFSTR("+/:"),
        kCFStringEncodingUTF8));
}

-(void)showAlert:(NSString*)msg
{
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
