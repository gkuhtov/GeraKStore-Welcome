#import <Foundation/Foundation.h>

@interface UserDefaultsWelcome : NSObject
+ (BOOL)hasSeenWelcome;
+ (void)setHasSeenWelcome:(BOOL)value;
@end
