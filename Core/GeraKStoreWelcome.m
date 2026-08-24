#import "GeraKStoreWelcome.h"
#import "WelcomeManager.h"

@implementation GeraKStoreWelcome

+ (void)start {
    [[WelcomeManager sharedManager] startWelcomeIfNeeded];
}

@end
