#import "AppearanceConfig.h"

@implementation AppearanceConfig

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];

    if (self) {
        NSDictionary *glass = dict[@"glass"] ?: @{};

        _glassBlurRadius = [glass[@"blurRadius"] floatValue];
        if (_glassBlurRadius <= 0.0) {
            _glassBlurRadius = 45.0;
        }

        _glassOpacity = [glass[@"opacity"] floatValue];
        if (_glassOpacity <= 0.0) {
            _glassOpacity = 0.22;
        }

        _glassCornerRadius = [glass[@"cornerRadius"] floatValue];
        if (_glassCornerRadius <= 0.0) {
            _glassCornerRadius = 28.0;
        }

        _glassBorderWidth = [glass[@"borderWidth"] floatValue];
        if (_glassBorderWidth <= 0.0) {
            _glassBorderWidth = 0.8;
        }

        _glassBorderColor = glass[@"borderColor"] ?: @"#FFFFFF33";


        NSDictionary *logo = dict[@"logo"] ?: @{};

        _logoSize = [logo[@"size"] floatValue];
        if (_logoSize <= 0.0) {
            _logoSize = 110.0;
        }

        _logoTopOffset = [logo[@"topOffset"] floatValue];
        if (_logoTopOffset <= 0.0) {
            _logoTopOffset = 40.0;
        }


        NSDictionary *layout = dict[@"layout"] ?: @{};

        _cardMaxWidth = [layout[@"cardMaxWidth"] floatValue];
        if (_cardMaxWidth <= 0.0) {
            _cardMaxWidth = 340.0;
        }

        _buttonHeight = [layout[@"buttonHeight"] floatValue];
        if (_buttonHeight <= 0.0) {
            _buttonHeight = 52.0;
        }

        _spacing = [layout[@"spacing"] floatValue];
        if (_spacing <= 0.0) {
            _spacing = 16.0;
        }


        NSDictionary *colors = dict[@"colors"] ?: @{};

        _primaryGradient =
        colors[@"primaryGradient"] ?:
        @[@"#FF4FA3", @"#FF7A59"];

        _backgroundGradient =
        colors[@"backgroundGradient"] ?:
        @[@"#0A0A1F", @"#1A0B2E", @"#2D1B4E"];

        _titleColor =
        colors[@"titleColor"] ?:
        @"#FFFFFF";

        _subtitleColor =
        colors[@"subtitleColor"] ?:
        @"#FFFFFFAA";


        _showMountains =
        [dict[@"showMountains"] boolValue];

        _showStars =
        [dict[@"showStars"] boolValue];
    }

    return self;
}

@end
