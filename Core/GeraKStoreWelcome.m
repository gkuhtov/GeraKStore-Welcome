#import "GeraKStoreWelcome.h"
#import "WelcomeManager.h"

@implementation GeraKStoreWelcome

__attribute__((constructor))
static void GeraKStoreWelcomeLoad(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [GeraKStoreWelcome start];
    });
}

+ (void)start {
    [[WelcomeManager sharedManager] startWelcomeIfNeeded];
}

@end
