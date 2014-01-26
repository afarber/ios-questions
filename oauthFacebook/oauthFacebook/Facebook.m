#import "Facebook.h"

static NSString* const kAppId =    @"432298283565593";
static NSString* const kSecret =   @"c59d4f8cc0a15a0ad4090c3405729d8e";
static NSString* const kAuthUrl =  @"https://graph.facebook.com/oauth/authorize?response_type=token&client_id=%@&redirect_uri=%@&state=%d";
static NSString* const kRedirect = @"https://www.facebook.com/connect/login_success.html";
static NSString* const kAvatar =   @"http://graph.facebook.com/%@/picture?type=large";
static NSString* const kMe =       @"https://graph.facebook.com/me?access_token=%@";

@implementation Facebook

- (NSString*)buildLoginStr
{
    int state = arc4random_uniform(1000);
    NSString *redirect = [kRedirect stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:kAuthUrl, kAppId, redirect, state];
}

- (BOOL)shouldFetchToken
{
    return NO;
}

- (NSString *)extractCodeFromStr:(NSString*)str FromTitle:(NSString*)title
{
    return nil;
}

- (NSString *)extractTokenFromStr:(NSString*)str FromTitle:(NSString*)title
{
    return [self extractValueFrom:str ForKey:@"access_token"];
}

- (NSURLRequest*)buildTokenUrlWithCode:(NSString*)code
{
    return nil;
}

- (NSString*)extractTokenFromJson:(id)json
{
    if (![json isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Parsing response failed");
        return nil;
    }
    
    NSDictionary *dict = json;
    return dict[@"access_token"];
}

- (NSURLRequest*)buildMeUrlWithToken:(NSString*)token
{
    NSString *str = [NSString stringWithFormat:kMe, token];
    NSURL *url = [NSURL URLWithString:str];
    return [NSURLRequest requestWithURL:url];
}

- (User*)createUserFromJson:(id)json
{
    if (![json isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Parsing response failed");
        return nil;
    }
    
    NSDictionary *dict = json;
    
    User *user = [[User alloc] init];
    user.userId    = dict[@"id"];
    user.firstName = dict[@"first_name"];
    user.lastName  = dict[@"last_name"];
    user.city      = dict[@"location"][@"name"];
    user.avatar    = [NSString stringWithFormat:kAvatar, dict[@"id"]];
    user.female    = ([@"female" caseInsensitiveCompare:dict[@"gender"]] == NSOrderedSame);
    
    return user;
}

- (NSString*)extractValueFrom:(NSString*)str ForKey:(NSString*)key
{
    NSString *value = nil;
    NSString *pattern = [key stringByAppendingString:@"=([^?&=]+)"];
    
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                      options:0
                                                                        error:nil];
    NSRange searchRange = NSMakeRange(0, [str length]);
    NSTextCheckingResult* result = [regex firstMatchInString:str options:0 range:searchRange];
    
    if (result) {
        value = [str substringWithRange:[result rangeAtIndex:1]];
    }
    
    return value;
}

@end
