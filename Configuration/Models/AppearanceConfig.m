#import "AppearanceConfig.h"

@implementation AppearanceConfig
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        NSDictionary *glass = dict[@"glass"] ?: @{};
        _glassBlurRadius = [glass[@"blurRadius"] floatValue] ?: 45.0;
        _glassOpacity = [glass[@"opacity"] floatValue] ?: 0.22;
        _glassCornerRadius = [glass[@"cornerRadius"] floatValue] ?: 28.0;
        
        NSDictionary *logo = dict[@"logo"] ?: @{};
        _logoSize = [logo[@"size"] floatValue] ?: 110.0;
        
        NSDictionary *layout = dict[@"layout"] ?: @{};
        _cardMaxWidth = [layout[@"cardMaxWidth"] floatValue] ?: 340.0;
        _buttonHeight = [layout[@"buttonHeight"] floatValue] ?: 52.0;
        
        NSDictionary *colors = dict[@"colors"] ?: @{};
        _primaryGradient = colors[@"primaryGradient"] ?: @[@"#FF4FA3", @"#FF7A59"];
        _backgroundGradient = colors[@"backgroundGradient"] ?: @[@"#0A0A1F", @"#1A0B2E", @"#2D1B4E"];
        
        _showMountains = [dict[@"showMountains"] boolValue];
        _showStars = [dict[@"showStars"] boolValue];
    }
    return self;
}
@end
