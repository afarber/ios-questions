#import <Foundation/Foundation.h>
#import "User.h"

@protocol SocialNetwork <NSObject>

- (NSString*)buildLoginStr;
- (NSString*)extractCodeFromStr:(NSString*)str FromTitle:(NSString*)title;
- (NSURLRequest*)buildTokenUrlWithCode:(NSString*)code;
- (NSString*)extractTokenFromJson:(id)json;
- (NSURLRequest*)buildMeUrlWithToken:(NSString*)token;
- (User*)createUserFromJson:(id)json;

@end
