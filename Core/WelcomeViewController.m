#import "EmbeddedResourceLoader.h"
#import "WelcomeViewController.h"
#import "WelcomeConfig.h"
#import "UserDefaults+Welcome.h"

@interface WelcomeViewController ()

@property (nonatomic, strong) CAGradientLayer *backgroundGradientLayer;

@property (nonatomic, strong) UIVisualEffectView *glassView;
@property (nonatomic, strong) UIView *glassTintView;

@property (nonatomic, strong) UIImageView *logoView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;

@property (nonatomic, strong) UIButton *telegramButton;
@property (nonatomic, strong) UIButton *githubButton;
@property (nonatomic, strong) UIButton *continueButton;
@property (nonatomic, strong) UIButton *dontShowAgainButton;

@property (nonatomic, strong) UIStackView *contentStack;
@property (nonatomic, strong) UIStackView *socialStack;

@end

@implementation WelcomeViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.modalPresentationStyle =
        UIModalPresentationFullScreen;

    self.view.backgroundColor =
        UIColor.blackColor;

    self.view.opaque = YES;

    [self setupBackground];
    [self setupGlass];
    [self setupInterface];
    [self setupActions];
    [self animateInterface];
}

#pragma mark - Configuration

- (WelcomeConfig *)config {
    return [WelcomeConfig sharedConfig];
}

#pragma mark - Background

- (void)setupBackground {

    AppearanceConfig *appearance =
        self.config.appearanceConfig;

    NSArray *colors =
        appearance.backgroundGradient;

    NSMutableArray *cgColors =
        [NSMutableArray array];

    for (NSString *hex in colors) {

        UIColor *color =
            [self colorFromHex:hex];

        if (color) {
            [cgColors addObject:
                (id)color.CGColor];
        }
    }

    if (cgColors.count == 0) {

        [cgColors addObject:
            (id)UIColor.blackColor.CGColor];

        [cgColors addObject:
            (id)UIColor.darkGrayColor.CGColor];
    }

    self.backgroundGradientLayer =
        [CAGradientLayer layer];

    self.backgroundGradientLayer.colors =
        cgColors;

    self.backgroundGradientLayer.startPoint =
        CGPointMake(0.0, 0.0);

    self.backgroundGradientLayer.endPoint =
        CGPointMake(1.0, 1.0);

    self.backgroundGradientLayer.frame =
        self.view.bounds;

    [self.view.layer
        insertSublayer:self.backgroundGradientLayer
        atIndex:0];
}

#pragma mark - Glass

- (void)setupGlass {

    AppearanceConfig *appearance =
        self.config.appearanceConfig;

    UIVisualEffect *effect = nil;

    if (@available(iOS 26.0, *)) {

        UIGlassEffect *glass =
            [UIGlassEffect effectWithStyle:
                UIGlassEffectStyleClear];

        glass.interactive = NO;

        effect = glass;

    } else {

        effect =
            [UIBlurEffect effectWithStyle:
                UIBlurEffectStyleSystemUltraThinMaterialDark];
    }

    self.glassView =
        [[UIVisualEffectView alloc]
            initWithEffect:effect];

    self.glassView.translatesAutoresizingMaskIntoConstraints =
        NO;

    self.glassView.layer.cornerRadius =
        appearance.glassCornerRadius;

    self.glassView.clipsToBounds =
        YES;

    if (@available(iOS 26.0, *)) {

        self.glassView.layer.borderWidth =
            0.0;

        self.glassView.layer.borderColor =
            UIColor.clearColor.CGColor;

    } else {

        self.glassView.layer.borderWidth =
            appearance.glassBorderWidth;

        self.glassView.layer.borderColor =
            [self colorFromHex:
                appearance.glassBorderColor].CGColor;
    }

    [self.view addSubview:self.glassView];
}

#pragma mark - Interface

- (void)setupInterface {

    AppearanceConfig *appearance =
        self.config.appearanceConfig;

    TextConfig *text =
        self.config.textConfig;

    self.contentStack =
        [[UIStackView alloc] init];

    self.contentStack.translatesAutoresizingMaskIntoConstraints =
        NO;

    self.contentStack.axis =
        UILayoutConstraintAxisVertical;

    self.contentStack.alignment =
        UIStackViewAlignmentFill;

    self.contentStack.distribution =
        UIStackViewDistributionFill;

    self.contentStack.spacing =
        appearance.spacing;

    [self.glassView.contentView
        addSubview:self.contentStack];

    [NSLayoutConstraint activateConstraints:@[

        [self.glassView.centerXAnchor
            constraintEqualToAnchor:
                self.view.centerXAnchor],

        [self.glassView.centerYAnchor
            constraintEqualToAnchor:
                self.view.centerYAnchor],

        [self.glassView.leadingAnchor
            constraintGreaterThanOrEqualToAnchor:
                self.view.leadingAnchor
                constant:20.0],

        [self.glassView.trailingAnchor
            constraintLessThanOrEqualToAnchor:
                self.view.trailingAnchor
                constant:-20.0],

        [self.glassView.widthAnchor
            constraintLessThanOrEqualToConstant:
                appearance.cardMaxWidth],

        [self.contentStack.topAnchor
            constraintEqualToAnchor:
                self.glassView.contentView.topAnchor
                constant:28.0],

        [self.contentStack.leadingAnchor
            constraintEqualToAnchor:
                self.glassView.contentView.leadingAnchor
                constant:22.0],

        [self.contentStack.trailingAnchor
            constraintEqualToAnchor:
                self.glassView.contentView.trailingAnchor
                constant:-22.0],

        [self.contentStack.bottomAnchor
            constraintEqualToAnchor:
                self.glassView.contentView.bottomAnchor
                constant:-20.0]
    ]];

    [self setupLogo];

    [self setupTitle:text.title];

    [self setupSubtitle:text.subtitle];

    [self setupSocialButtons];

    [self setupContinueButton];

    [self setupDontShowAgain:text.dontShowAgain];
}

#pragma mark - Logo

- (void)setupLogo {

    AppearanceConfig *appearance =
        self.config.appearanceConfig;

    UIImage *image =
        [EmbeddedResourceLoader
            imageForResource:@"GeraKStoreWelcome"
            extension:@"png"];

    if (!image) {
        image =
            [EmbeddedResourceLoader
                imageForResource:@"GeraKStoreWelcome"
                extension:@"jpeg"];
    }

    self.logoView =
        [[UIImageView alloc]
            initWithImage:image];

    self.logoView.translatesAutoresizingMaskIntoConstraints =
        NO;

    self.logoView.contentMode =
        UIViewContentModeScaleAspectFit;

    self.logoView.clipsToBounds =
        YES;

    [self.contentStack
        addArrangedSubview:self.logoView];

    [NSLayoutConstraint activateConstraints:@[

        [self.logoView.heightAnchor
            constraintEqualToConstant:
                appearance.logoSize]
    ]];
}

#pragma mark - Title

- (void)setupTitle:(NSString *)title {

    AppearanceConfig *appearance =
        self.config.appearanceConfig;

    self.titleLabel =
        [[UILabel alloc] init];

    self.titleLabel.text =
        title;

    self.titleLabel.textAlignment =
        NSTextAlignmentCenter;

    self.titleLabel.textColor =
        [self colorFromHex:
            appearance.titleColor];

    self.titleLabel.font =
        [UIFont systemFontOfSize:28.0
                          weight:UIFontWeightBold];

    self.titleLabel.numberOfLines =
        1;

    [self.contentStack
        addArrangedSubview:self.titleLabel];
}

#pragma mark - Subtitle

- (void)setupSubtitle:(NSString *)subtitle {

    AppearanceConfig *appearance =
        self.config.appearanceConfig;

    self.subtitleLabel =
        [[UILabel alloc] init];

    self.subtitleLabel.text =
        subtitle;

    self.subtitleLabel.textAlignment =
        NSTextAlignmentCenter;

    self.subtitleLabel.textColor =
        [self colorFromHex:
            appearance.subtitleColor];

    self.subtitleLabel.font =
        [UIFont systemFontOfSize:14.0
                          weight:UIFontWeightRegular];

    self.subtitleLabel.numberOfLines =
        0;

    self.subtitleLabel.lineBreakMode =
        NSLineBreakByWordWrapping;

    [self.contentStack
        addArrangedSubview:self.subtitleLabel];
}

#pragma mark - Social Buttons

- (void)setupSocialButtons {

    TextConfig *text =
        self.config.textConfig;

    self.socialStack =
        [[UIStackView alloc] init];

    self.socialStack.axis =
        UILayoutConstraintAxisHorizontal;

    self.socialStack.spacing =
        10.0;

    self.socialStack.distribution =
        UIStackViewDistributionFillEqually;

    [self.contentStack
        addArrangedSubview:self.socialStack];

    self.telegramButton =
        [self createGlassButtonWithTitle:
            text.telegramButton];

    self.githubButton =
        [self createGlassButtonWithTitle:
            text.githubButton];

    [self.socialStack
        addArrangedSubview:self.telegramButton];

    [self.socialStack
        addArrangedSubview:self.githubButton];

    [NSLayoutConstraint activateConstraints:@[

        [self.socialStack.heightAnchor
            constraintEqualToConstant:50.0]
    ]];
}

#pragma mark - Continue

- (void)setupContinueButton {

    TextConfig *text =
        self.config.textConfig;

    self.continueButton =
        [self createPrimaryButtonWithTitle:
            text.continueButton];

    [self.contentStack
        addArrangedSubview:self.continueButton];

    [NSLayoutConstraint activateConstraints:@[

        [self.continueButton.heightAnchor
            constraintEqualToConstant:
                self.config.appearanceConfig.buttonHeight]
    ]];
}

#pragma mark - Don't Show Again

- (void)setupDontShowAgain:(NSString *)title {

    self.dontShowAgainButton =
        [UIButton buttonWithType:
            UIButtonTypeSystem];

    self.dontShowAgainButton.translatesAutoresizingMaskIntoConstraints =
        NO;

    [self.dontShowAgainButton
        setTitle:title
        forState:UIControlStateNormal];

    [self.dontShowAgainButton
        setTitleColor:
            [UIColor.whiteColor
                colorWithAlphaComponent:0.55]
        forState:UIControlStateNormal];

    self.dontShowAgainButton.titleLabel.font =
        [UIFont systemFontOfSize:13.0
                          weight:UIFontWeightMedium];

    [self.contentStack
        addArrangedSubview:self.dontShowAgainButton];

    [NSLayoutConstraint activateConstraints:@[

        [self.dontShowAgainButton.heightAnchor
            constraintEqualToConstant:30.0]
    ]];
}

#pragma mark - Buttons

- (UIButton *)createGlassButtonWithTitle:(NSString *)title {

    UIButton *button = nil;

    if (@available(iOS 26.0, *)) {

        UIButtonConfiguration *configuration =
            [UIButtonConfiguration glassButtonConfiguration];

        configuration.title =
            title;

        configuration.baseForegroundColor =
            UIColor.whiteColor;

        configuration.cornerStyle =
            UIButtonConfigurationCornerStyleCapsule;

        configuration.contentInsets =
            NSDirectionalEdgeInsetsMake(
                0.0,
                16.0,
                0.0,
                16.0
            );

        button =
            [UIButton buttonWithConfiguration:
                configuration
                              primaryAction:nil];

    } else {

        button =
            [UIButton buttonWithType:
                UIButtonTypeSystem];

        button.backgroundColor =
            [UIColor.whiteColor
                colorWithAlphaComponent:0.10];

        [button setTitle:title
                forState:UIControlStateNormal];

        [button setTitleColor:
            UIColor.whiteColor
                forState:UIControlStateNormal];

        button.layer.cornerRadius =
            16.0;

        button.layer.borderWidth =
            0.8;

        button.layer.borderColor =
            [UIColor.whiteColor
                colorWithAlphaComponent:0.20].CGColor;
    }

    button.translatesAutoresizingMaskIntoConstraints =
        NO;

    return button;
}

- (UIButton *)createPrimaryButtonWithTitle:(NSString *)title {

    UIButton *button = nil;

    if (@available(iOS 26.0, *)) {

        UIButtonConfiguration *configuration =
            [UIButtonConfiguration glassButtonConfiguration];

        configuration.title =
            title;

        configuration.baseForegroundColor =
            UIColor.whiteColor;

        configuration.cornerStyle =
            UIButtonConfigurationCornerStyleCapsule;

        configuration.contentInsets =
            NSDirectionalEdgeInsetsMake(
                0.0,
                20.0,
                0.0,
                20.0
            );

        button =
            [UIButton buttonWithConfiguration:
                configuration
                              primaryAction:nil];

    } else {

        button =
            [UIButton buttonWithType:
                UIButtonTypeSystem];

        button.backgroundColor =
            [UIColor.whiteColor
                colorWithAlphaComponent:0.16];

        [button setTitle:title
                forState:UIControlStateNormal];

        [button setTitleColor:
            UIColor.whiteColor
                forState:UIControlStateNormal];

        button.layer.cornerRadius =
            18.0;

        button.layer.borderWidth =
            0.8;

        button.layer.borderColor =
            [UIColor.whiteColor
                colorWithAlphaComponent:0.24].CGColor;
    }

    button.translatesAutoresizingMaskIntoConstraints =
        NO;

    return button;
}

#pragma mark - Actions

- (void)setupActions {

    [self.telegramButton
        addTarget:self
        action:@selector(openTelegram)
        forControlEvents:UIControlEventTouchUpInside];

    [self.githubButton
        addTarget:self
        action:@selector(openGitHub)
        forControlEvents:UIControlEventTouchUpInside];

    [self.continueButton
        addTarget:self
        action:@selector(continuePressed)
        forControlEvents:UIControlEventTouchUpInside];

    [self.dontShowAgainButton
        addTarget:self
        action:@selector(dontShowAgainPressed)
        forControlEvents:UIControlEventTouchUpInside];
}

- (void)openTelegram {

    NSString *urlString =
        self.config.linksConfig.telegram;

    [self openURLString:urlString];
}

- (void)openGitHub {

    NSString *urlString =
        self.config.linksConfig.github;

    [self openURLString:urlString];
}

- (void)continuePressed {

    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)dontShowAgainPressed {

    [UserDefaultsWelcome
        markWelcomeAsSeen];

    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

#pragma mark - URL

- (void)openURLString:(NSString *)string {

    if (string.length == 0) {
        return;
    }

    NSURL *url =
        [NSURL URLWithString:string];

    if (!url) {
        return;
    }

    if (@available(iOS 10.0, *)) {

        [[UIApplication sharedApplication]
            openURL:url
            options:@{}
            completionHandler:nil];

    } else {

        [[UIApplication sharedApplication]
            openURL:url];
    }
}

#pragma mark - Animation

- (void)animateInterface {

    if (!self.config.appConfig.animationEnabled) {
        return;
    }

    self.glassView.alpha =
        0.0;

    self.glassView.transform =
        CGAffineTransformMakeScale(
            0.96,
            0.96
        );

    [UIView animateWithDuration:
        0.45
        delay:0.0
        usingSpringWithDamping:0.86
        initialSpringVelocity:0.3
        options:UIViewAnimationOptionCurveEaseOut
        animations:^{

            self.glassView.alpha =
                1.0;

            self.glassView.transform =
                CGAffineTransformIdentity;

        }
        completion:nil];
}

#pragma mark - Color

- (UIColor *)colorFromHex:(NSString *)hex {

    if (![hex isKindOfClass:NSString.class]) {
        return nil;
    }

    NSString *value =
        [hex stringByReplacingOccurrencesOfString:@"#"
                                        withString:@""];

    unsigned int color = 0;

    [[NSScanner scannerWithString:value]
        scanHexInt:&color];

    if (value.length == 6) {

        CGFloat r =
            ((color >> 16) & 0xFF) / 255.0;

        CGFloat g =
            ((color >> 8) & 0xFF) / 255.0;

        CGFloat b =
            (color & 0xFF) / 255.0;

        return
            [UIColor colorWithRed:r
                             green:g
                              blue:b
                             alpha:1.0];
    }

    if (value.length == 8) {

        CGFloat r =
            ((color >> 24) & 0xFF) / 255.0;

        CGFloat g =
            ((color >> 16) & 0xFF) / 255.0;

        CGFloat b =
            ((color >> 8) & 0xFF) / 255.0;

        CGFloat a =
            (color & 0xFF) / 255.0;

        return
            [UIColor colorWithRed:r
                             green:g
                              blue:b
                             alpha:a];
    }

    return nil;
}

@end
