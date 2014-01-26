#import <Foundation/Foundation.h>
#import "User.h"

@protocol SocialNetwork <NSObject>

- (NSURLRequest*)loginReq;
- (BOOL)shouldFetchToken;
- (NSURLRequest*)tokenReqWithStr:(NSString*)str AndTitle:(NSString*)title;
- (NSURLRequest*)userReqWithStr:(NSString*)str AndTitle:(NSString*)title;
- (NSURLRequest*)userReqWithJson:(id)json;
- (User*)createUserFromJson:(id)json;

@end
