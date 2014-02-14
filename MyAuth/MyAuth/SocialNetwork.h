#import <Foundation/Foundation.h>
#import "User.h"

static NSString* const kKey   = @"key";
static NSString* const kLabel = @"label";
static NSString* const kObj   = @"object";

static NSString* const kGC = @"GC";
static NSString* const kFB = @"FB";
static NSString* const kGG = @"GG";
static NSString* const kMR = @"MR";
static NSString* const kOK = @"OK";
static NSString* const kVK = @"VK";

@protocol SocialNetwork <NSObject>

- (NSURLRequest*)loginReq;
- (BOOL)shouldFetchToken;
- (NSURLRequest*)tokenReqWithStr:(NSString*)str AndTitle:(NSString*)title;
- (NSURLRequest*)userReqWithStr:(NSString*)str AndTitle:(NSString*)title;
- (NSURLRequest*)userReqWithJson:(id)json;
- (User*)createUserFromJson:(id)json;

@end
