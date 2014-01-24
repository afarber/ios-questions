#import "Google.h"

static NSString* const kAppId =    @"441988749325-h8bsf01r3jnv5nbsb31a8pi99660oe0q.apps.googleusercontent.com";
static NSString* const kSecret =   @"YjnMME25A-2qvasUQbjM52vN";
static NSString* const kAuthUrl =  @"https://accounts.google.com/o/oauth2/auth?response_type=code&scope=profile&client_id=%@&redirect_uri=%@&state=%d";
static NSString* const kRedirect = @"urn:ietf:wg:oauth:2.0:oob";
static NSString* const kTokenUrl = @"https://accounts.google.com/o/oauth2/token";
static NSString* const kBody =     @"grant_type=authorization_code&code=%@&client_id=%@&redirect_uri=%@&client_secret=%@";
static NSString* const kMe =       @"https://www.googleapis.com/oauth2/v1/userinfo?access_token=";

@implementation Google

- (NSString*)buildLoginStr
{
    int state = arc4random_uniform(1000);
    NSString *redirect = [kRedirect stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:kAuthUrl, kAppId, redirect, state];
}

- (NSString *)extractCodeFromStr:(NSString*)str FromTitle:(NSString*)title
{
    return [self extractValueFrom:title ForKey:@"code"];
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
        NSLog(@"%s: value=%@", __PRETTY_FUNCTION__, value);
    }
    
    return value;
}

- (NSURLRequest*)buildTokenUrlWithCode:(NSString*)code
{
    NSString *redirect = [kRedirect stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:kTokenUrl];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"POST"];
    
    NSString *body = [NSString stringWithFormat:kBody,
                      code, kAppId, redirect, kSecret];
    [req setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    return req;
}

- (NSString*)extractTokenFromJson:(id)json
{
    if (![json isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Parsing response failed");
        return nil;
    }
    
    NSDictionary *dict = json;
    NSString *token = dict[@"access_token"];
    return token;
}

- (NSURLRequest*)buildMeUrlWithToken:(NSString*)token
{
    NSString *str = [kMe stringByAppendingString:token];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    return req;
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
    user.firstName = dict[@"given_name"];
    user.lastName  = dict[@"family_name"];
    //user.city    = dict[@"PlacesLived"][0][@"value"];
    user.avatar    = dict[@"picture"];
    user.female    = ([@"female" caseInsensitiveCompare:dict[@"gender"]] == NSOrderedSame);
    
    return user;
}

@end
