#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding>

@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *avatar;
@property (assign, nonatomic) BOOL female;

-(void)save;
+(User*)load;
+(User*)loadForKey:(NSString*)key;
+(void)reset;

@end
