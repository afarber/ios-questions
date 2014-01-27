#import <CommonCrypto/CommonDigest.h>
#import "Odnoklassniki.h"

static NSString* const kAppId =    @"217129728";
static NSString* const kPublic =   @"CBAECCPNABABABABA";
static NSString* const kSecret =   @"EE9D964651AE21C64F74D094";
static NSString* const kAuthUrl =  @"http://www.odnoklassniki.ru/oauth/authorize?response_type=code&display=touch&layout=m&client_id=%@&redirect_uri=%@";
static NSString* const kRedirect = @"http://connect.mail.ru/oauth/success.html";
static NSString* const kTokenUrl = @"http://api.odnoklassniki.ru/oauth/token.do";
static NSString* const kBody =     @"grant_type=authorization_code&code=%@&client_id=%@&redirect_uri=%@&client_secret=%@";
static NSString* const kParams =   @"application_key=%@format=JSONmethod=users.getCurrentUser";
static NSString* const kMe =       @"http://api.odnoklassniki.ru/fb.do?application_key=%@&format=JSON&method=users.getCurrentUser&access_token=%@&sig=%@";

@implementation Odnoklassniki

- (NSURLRequest*)loginReq
{
    NSString *redirect = [kRedirect stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSString stringWithFormat:kAuthUrl, kAppId, redirect];
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
    
    NSString *code = [self extractValueFrom:str ForKey:@"code"];
    
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
    NSString *params = [NSString stringWithFormat:kParams, kPublic];
    
    NSString *sig = [self md5:[NSString stringWithFormat:@"%@%@", token, kSecret]];
    sig = [self md5:[NSString stringWithFormat:@"%@%@", params, sig]];
    
    NSString *str = [NSString stringWithFormat:kMe, kPublic, token, sig];
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
    user.userId    = dict[@"uid"];
    user.firstName = dict[@"first_name"];
    user.lastName  = dict[@"last_name"];
    user.city      = dict[@"location"][@"city"];
    user.avatar    = dict[@"pic_2"];
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

- (NSString *) md5:(NSString *)input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5(cStr, strlen(cStr), digest);
    
    NSMutableString *str = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [str appendFormat:@"%02x", digest[i]];
    
    return str;
}

@end

