#import "FirstLaunchManager.h"

static NSString * const GeraKStoreWelcomeHiddenKey = @"GeraKStoreWelcomeHidden";

@implementation FirstLaunchManager

+ (instancetype)sharedManager {
    static FirstLaunchManager *manager;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        manager = [[FirstLaunchManager alloc] init];
    });

    return manager;
}

- (BOOL)shouldShowWelcome {
    BOOL welcomeHidden = [[NSUserDefaults standardUserDefaults]
                          boolForKey:GeraKStoreWelcomeHiddenKey];

    if (welcomeHidden) {
        return NO;
    }

    return YES;
}

- (void)disableWelcome {
    [[NSUserDefaults standardUserDefaults]
        setBool:YES
        forKey:GeraKStoreWelcomeHiddenKey];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
