#import "LinksConfig.h"

@implementation LinksConfig
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _telegram = dict[@"telegram"] ?: @"";
        _github = dict[@"github"] ?: @"";
    }
    return self;
}
@end
