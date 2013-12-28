#import "ViewController.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *facebookAccountType = [accountStore accountTypeWithAccountTypeIdentifier: ACAccountTypeIdentifierFacebook];
    
    NSDictionary *options = @{
                              ACFacebookAudienceKey : ACFacebookAudienceEveryone,
                              ACFacebookAppIdKey : @"432298283565593",
                              ACFacebookPermissionsKey : @[@"id",
                                                           @"first_name",
                                                           @"gender",
                                                           @"location"]};
    
    [accountStore requestAccessToAccountsWithType:facebookAccountType options:options completion:^(BOOL granted, NSError *error)
    {
        if (granted)
        {
            NSLog(@"Basic access granted");
            
            /*
            NSURL *requestURL = [NSURL URLWithString:
                                 @"https://graph.facebook.com/me/"];
            
            NSDictionary *params = @{
                                      @"AAA" : @"BBB",
                                      @"CCC" : @"DDD"};
            
            SLRequest *postRequest = [SLRequest
                                      requestForServiceType:SLServiceTypeFacebook
                                      requestMethod:SLRequestMethodGET
                                      URL:requestURL parameters:params];
            
            postRequest.account = self.facebookAccount;
             */
        }
        else
        {
            NSLog(@"Basic access denied %@", error);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
