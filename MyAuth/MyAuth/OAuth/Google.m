#import "SocialNetwork.h"
#import "Google.h"

static NSString* const kAppId =    @"441988749325-h8bsf01r3jnv5nbsb31a8pi99660oe0q.apps.googleusercontent.com";
static NSString* const kSecret =   @"YjnMME25A-2qvasUQbjM52vN";
static NSString* const kAuthUrl =  @"https://accounts.google.com/o/oauth2/auth?response_type=code&scope=profile&client_id=%@&redirect_uri=%@&state=%d";
static NSString* const kRedirect = @"urn:ietf:wg:oauth:2.0:oob";
static NSString* const kTokenUrl = @"https://accounts.google.com/o/oauth2/token";
static NSString* const kBody =     @"grant_type=authorization_code&code=%@&client_id=%@&redirect_uri=%@&client_secret=%@";
static NSString* const kMe =       @"https://www.googleapis.com/oauth2/v1/userinfo?access_token=%@";

@implementation Google

- (NSURLRequest*)loginReq
{
    int state = arc4random_uniform(1000);
    NSString *redirect = [kRedirect stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSString stringWithFormat:kAuthUrl, kAppId, redirect, state];
    NSURL *url = [NSURL URLWithString:str];
    return [NSURLRequest requestWithURL:url];
}

- (BOOL)shouldFetchToken
{
    return YES;
}

- (NSURLRequest*)tokenReqWithStr:(NSString*)str AndTitle:(NSString*)title
{
    NSMutableURLRequest *req = nil;
    
    NSString *code = [self extractValueFrom:title ForKey:@"code"];
    
    if (code) {
        NSString *redirect = [kRedirect stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:kTokenUrl];
        req = [NSMutableURLRequest requestWithURL:url];
        [req setHTTPMethod:@"POST"];
        NSString *body = [NSString stringWithFormat:kBody, code, kAppId, redirect, kSecret];
        [req setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return req;
}

- (NSURLRequest*)userReqWithStr:(NSString*)str AndTitle:(NSString*)title
{
    return nil;
}

- (NSURLRequest*)userReqWithJson:(id)json
{
    if (![json isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Parsing response failed");
        return nil;
    }
    
    NSDictionary *dict = json;
    NSString *token = dict[@"access_token"];
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
    user.key       = kGG;
    user.userId    = dict[@"id"];
    user.firstName = dict[@"given_name"];
    user.lastName  = dict[@"family_name"];
    //user.city    = dict[@"PlacesLived"][0][@"value"];
    user.avatar    = dict[@"picture"];
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
