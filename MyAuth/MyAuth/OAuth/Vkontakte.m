#import "SocialNetwork.h"
#import "Vkontakte.h"

static NSString* const kAppId =    @"4132525";
static NSString* const kSecret =   @"ar3IMdDaDzcUDUHj3rsl";
static NSString* const kAuthUrl =  @"http://oauth.vk.com/authorize?response_type=token&display=touch&client_id=%@&redirect_uri=%@";
static NSString* const kRedirect = @"http://oauth.vk.com/blank.html";
static NSString* const kMe =       @"https://api.vk.com/method/getProfiles?fields=sex,city,photo_big&format=JSON&uids=%@&access_token=%@";

@implementation Vkontakte

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
    NSString *userId = [self extractValueFrom:str ForKey:@"user_id"];

    if (token && userId) {
        NSString *me = [NSString stringWithFormat:kMe, userId, token];
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
    if (![json isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Parsing response failed");
        return nil;
    }
    
    NSDictionary *dict = json[@"response"][0];
    
    User *user = [[User alloc] init];
    user.key       = kVK;
    user.userId    = dict[@"uid"];
    user.firstName = dict[@"first_name"];
    user.lastName  = dict[@"last_name"];
    user.city      = [NSString stringWithFormat:@"%@", dict[@"city"]];
    user.avatar    = dict[@"photo_big"];
    user.female    = (2 == [dict[@"female"] intValue]);
    
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
