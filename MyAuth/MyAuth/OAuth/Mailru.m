#import <CommonCrypto/CommonDigest.h>
#import "SocialNetwork.h"
#import "Mailru.h"

static NSString* const kAppId =    @"715360";
static NSString* const kSecret =   @"60648c6d79654e4b1d99abe784ff6f63";
static NSString* const kAuthUrl =  @"https://connect.mail.ru/oauth/authorize?response_type=token&display=touch&client_id=%@&redirect_uri=%@";
static NSString* const kRedirect = @"http://connect.mail.ru/oauth/success.html";
static NSString* const kParams =   @"%@app_id=%@method=users.getInfosession_key=%@uids=%@%@";
static NSString* const kMe =       @"http://www.appsmail.ru/platform/api?app_id=%@&method=users.getInfo&session_key=%@&uids=%@&sig=%@";

@implementation Mailru

- (NSURLRequest*)loginReq
{
    NSString *redirect = [kRedirect stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSString stringWithFormat:kAuthUrl, kAppId, redirect];
    NSURL *url = [NSURL URLWithString:str];
    return [NSURLRequest requestWithURL:url];
}

- (BOOL)shouldFetchToken
{
    return NO;
}

- (NSURLRequest*)tokenReqWithStr:(NSString*)str AndTitle:(NSString*)title
{
    return nil;
}

- (NSURLRequest*)userReqWithStr:(NSString*)str AndTitle:(NSString*)title
{
    NSURLRequest *req = nil;
    
    NSString *token = [self extractValueFrom:str ForKey:@"access_token"];
    NSString *userId = [self extractValueFrom:str ForKey:@"x_mailru_vid"];
    
    if (token && userId) {
        NSString *sig = [self md5:[NSString stringWithFormat:kParams, userId, kAppId, token, userId, kSecret]];
        NSString *me = [NSString stringWithFormat:kMe, kAppId, token, userId, sig];
        NSURL *url = [NSURL URLWithString:me];
        req = [NSURLRequest requestWithURL:url];
    }
    
    return req;
}

- (NSURLRequest*)userReqWithJson:(id)json
{
    return nil;
}

- (User*)createUserFromJson:(id)json
{
    if (![json isKindOfClass:[NSArray class]]) {
        NSLog(@"Parsing response failed");
        return nil;
    }
    
    NSDictionary *dict = json[0];
    
    User *user = [[User alloc] init];
    user.key       = kMR;
    user.userId    = dict[@"uid"];
    user.firstName = dict[@"first_name"];
    user.lastName  = dict[@"last_name"];
    user.city      = dict[@"location"][@"city"][@"name"];
    user.avatar    = dict[@"pic_big"];
    user.female    = [dict[@"sex"] boolValue];
    
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
