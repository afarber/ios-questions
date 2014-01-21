#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *avatar;
@property (assign, nonatomic) BOOL female;

@end
