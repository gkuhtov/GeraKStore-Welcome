#import "UserDefaults+Welcome.h"

static NSString * const kHasSeenWelcomeKey = @"GeraKStoreWelcome.hasSeenWelcome";

@implementation UserDefaultsWelcome

+ (BOOL)hasSeenWelcome {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kHasSeenWelcomeKey];
}

+ (void)setHasSeenWelcome:(BOOL)value {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kHasSeenWelcomeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
