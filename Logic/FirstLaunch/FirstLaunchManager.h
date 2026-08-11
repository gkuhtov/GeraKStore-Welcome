#import <Foundation/Foundation.h>

@interface FirstLaunchManager : NSObject

+ (instancetype)sharedManager;

- (BOOL)shouldShowWelcome;
- (void)disableWelcome;

@end
