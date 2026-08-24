#import "AppConfig.h"

@implementation AppConfig
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _enabled = [dict[@"enabled"] boolValue];
        _showOnFirstLaunchOnly = [dict[@"showOnFirstLaunchOnly"] boolValue];
        _allowSkip = [dict[@"allowSkip"] boolValue];
        _animationEnabled = [dict[@"animationEnabled"] boolValue];
        _forceShowForDebug = [dict[@"forceShowForDebug"] boolValue];
    }
    return self;
}
@end
