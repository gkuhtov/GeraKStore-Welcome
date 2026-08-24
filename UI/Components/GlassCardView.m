#import "GlassCardView.h"

@implementation GlassCardView {
    UIVisualEffectView *_blurView;
}

- (instancetype)initWithBlurRadius:(CGFloat)radius opacity:(CGFloat)opacity cornerRadius:(CGFloat)cornerRadius {
    self = [super initWithFrame:CGRectZero];

    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:opacity];
        self.layer.cornerRadius = cornerRadius;
        self.layer.masksToBounds = YES;

        self.layer.borderWidth = 0.8;
        self.layer.borderColor =
            [UIColor colorWithWhite:1.0 alpha:0.2].CGColor;

        UIBlurEffect *blur =
            [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterialDark];

        _blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
        _blurView.translatesAutoresizingMaskIntoConstraints = NO;

        [self insertSubview:_blurView atIndex:0];

        [NSLayoutConstraint activateConstraints:@[
            [_blurView.topAnchor constraintEqualToAnchor:self.topAnchor],
            [_blurView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [_blurView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [_blurView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
        ]];
    }

    return self;
}

@end
