#import "TextConfig.h"

@implementation TextConfig
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _title = dict[@"title"] ?: @"Добро пожаловать";
        _subtitle = dict[@"subtitle"] ?: @"";
        _continueButton = dict[@"continueButton"] ?: @"Продолжить";
        _dontShowAgain = dict[@"dontShowAgain"] ?: @"Больше не показывать";
        _telegramButton = dict[@"telegramButton"] ?: @"Telegram";
        _githubButton = dict[@"githubButton"] ?: @"GitHub";
    }
    return self;
}
@end
