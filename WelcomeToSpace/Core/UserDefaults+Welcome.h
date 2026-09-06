#import <Foundation/Foundation.h>

@interface UserDefaultsWelcome : NSObject

+ (BOOL)hasSeenWelcome;
+ (void)markWelcomeAsSeen;
+ (void)resetWelcome;

@end
