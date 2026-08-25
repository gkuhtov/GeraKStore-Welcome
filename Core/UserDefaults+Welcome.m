#import "UserDefaults+Welcome.h"

static NSString * const kGeraKStoreWelcomeSeenKey = @"com.gkuhtov.GeraKStoreWelcome.hasSeenWelcome";

@implementation UserDefaultsWelcome

+ (BOOL)hasSeenWelcome {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kGeraKStoreWelcomeSeenKey];
}

+ (void)markWelcomeAsSeen {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kGeraKStoreWelcomeSeenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)resetWelcome {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kGeraKStoreWelcomeSeenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
