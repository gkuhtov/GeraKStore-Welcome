#import "WelcomeViewController.h"
#import "WelcomeConfig.h"
#import "UserDefaults+Welcome.h"

@interface WelcomeViewController ()

@property (nonatomic, strong) CAGradientLayer *backgroundGradientLayer;
@property (nonatomic, strong) CAShapeLayer *mountainsLayer;
@property (nonatomic, strong) CALayer *starsLayer;
@property (nonatomic, strong) UIVisualEffectView *glassView;
@property (nonatomic, strong) UIImageView *logoView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;

@property (nonatomic, strong) UIButton *telegramButton;
@property (nonatomic, strong) UIButton *githubButton;
@property (nonatomic, strong) UIButton *continueButton;
@property (nonatomic, strong) CAGradientLayer *continueGradientLayer;

@property (nonatomic, strong) UIButton *dontShowAgainButton;

@property (nonatomic, strong) UIStackView *contentStack;

@end

@implementation WelcomeViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.view.backgroundColor = UIColor.blackColor;

    [self setupBackground];
    [self setupDecorations];
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

    AppearanceConfig *appearance = self.config.appearanceConfig;

    NSArray *colors = appearance.backgroundGradient;

    NSMutableArray *cgColors = [NSMutableArray array];

    for (NSString *hex in colors) {
        UIColor *color = [self colorFromHex:hex];
        if (color) {
            [cgColors addObject:(id)color.CGColor];
        }
    }

    if (cgColors.count == 0) {
        [cgColors addObject:(id)UIColor.blackColor.CGColor];
        [cgColors addObject:(id)UIColor.darkGrayColor.CGColor];
    }

    self.backgroundGradientLayer = [CAGradientLayer layer];
    self.backgroundGradientLayer.colors = cgColors;
    self.backgroundGradientLayer.startPoint = CGPointMake(0.0, 0.0);
    self.backgroundGradientLayer.endPoint = CGPointMake(1.0, 1.0);

    [self.view.layer insertSublayer:self.backgroundGradientLayer atIndex:0];
}

- (void)setupDecorations {

    AppearanceConfig *appearance = self.config.appearanceConfig;

    if (appearance.showStars) {

        self.starsLayer = [CALayer layer];
        self.starsLayer.frame = self.view.bounds;

        NSInteger starCount = 55;

        for (NSInteger i = 0; i < starCount; i++) {

            CGFloat size = 1.0 + ((CGFloat)arc4random_uniform(12) / 10.0);

            CALayer *star = [CALayer layer];

            star.bounds = CGRectMake(0, 0, size, size);

            CGFloat x =
            (CGFloat)arc4random() / (CGFloat)UINT32_MAX *
            self.view.bounds.size.width;

            CGFloat y =
            (CGFloat)arc4random() / (CGFloat)UINT32_MAX *
            self.view.bounds.size.height;

            star.position = CGPointMake(x, y);

            star.cornerRadius = size / 2.0;

            star.backgroundColor =
            [UIColor.whiteColor colorWithAlphaComponent:
             0.18 + ((CGFloat)arc4random_uniform(55) / 100.0)].CGColor;

            [self.starsLayer addSublayer:star];
        }

        [self.view.layer addSublayer:self.starsLayer];
    }

    if (appearance.showMountains) {

        self.mountainsLayer = [CAShapeLayer layer];
        self.mountainsLayer.frame = self.view.bounds;

        UIBezierPath *path = [UIBezierPath bezierPath];

        CGFloat width = self.view.bounds.size.width;
        CGFloat height = self.view.bounds.size.height;

        CGFloat baseY = height * 0.88;

        [path moveToPoint:CGPointMake(0, baseY)];

        [path addLineToPoint:
         CGPointMake(width * 0.16, height * 0.70)];

        [path addLineToPoint:
         CGPointMake(width * 0.28, height * 0.80)];

        [path addLineToPoint:
         CGPointMake(width * 0.46, height * 0.58)];

        [path addLineToPoint:
         CGPointMake(width * 0.62, height * 0.77)];

        [path addLineToPoint:
         CGPointMake(width * 0.78, height * 0.63)];

        [path addLineToPoint:
         CGPointMake(width, height * 0.76)];

        [path addLineToPoint:
         CGPointMake(width, baseY)];

        [path closePath];

        self.mountainsLayer.path = path.CGPath;

        self.mountainsLayer.fillColor =
        [UIColor.blackColor colorWithAlphaComponent:0.20].CGColor;

        self.mountainsLayer.strokeColor = UIColor.clearColor.CGColor;

        [self.view.layer addSublayer:self.mountainsLayer];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.backgroundGradientLayer.frame = self.view.bounds;

    if (self.starsLayer) {
        self.starsLayer.frame = self.view.bounds;
    }

    if (self.mountainsLayer) {
        self.mountainsLayer.frame = self.view.bounds;
    }

    if (self.continueGradientLayer) {
        self.continueGradientLayer.frame = self.continueButton.bounds;
        self.continueGradientLayer.cornerRadius = self.continueButton.layer.cornerRadius;
    }
}

#pragma mark - Interface

- (void)setupInterface {

    AppearanceConfig *appearance = self.config.appearanceConfig;
    TextConfig *text = self.config.textConfig;

    self.glassView = [[UIVisualEffectView alloc]
                      initWithEffect:
                      [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterialDark]];

    self.glassView.translatesAutoresizingMaskIntoConstraints = NO;
    self.glassView.alpha = appearance.glassOpacity;
    self.glassView.layer.cornerRadius = appearance.glassCornerRadius;
    self.glassView.clipsToBounds = YES;

    [self.view addSubview:self.glassView];

    [NSLayoutConstraint activateConstraints:@[
        [self.glassView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.glassView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.glassView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20.0],
        [self.glassView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20.0],
        [self.glassView.widthAnchor constraintLessThanOrEqualToConstant:520.0]
    ]];

    UIView *borderView = [[UIView alloc] init];
    borderView.translatesAutoresizingMaskIntoConstraints = NO;
    borderView.backgroundColor = UIColor.clearColor;
    borderView.layer.cornerRadius = appearance.glassCornerRadius;
    borderView.layer.borderWidth = appearance.glassBorderWidth;
    borderView.layer.borderColor = [self colorFromHex:appearance.glassBorderColor].CGColor;
    borderView.userInteractionEnabled = NO;

    [self.glassView.contentView addSubview:borderView];

    [NSLayoutConstraint activateConstraints:@[
        [borderView.topAnchor constraintEqualToAnchor:self.glassView.contentView.topAnchor],
        [borderView.bottomAnchor constraintEqualToAnchor:self.glassView.contentView.bottomAnchor],
        [borderView.leadingAnchor constraintEqualToAnchor:self.glassView.contentView.leadingAnchor],
        [borderView.trailingAnchor constraintEqualToAnchor:self.glassView.contentView.trailingAnchor]
    ]];

    self.contentStack = [[UIStackView alloc] init];
    self.contentStack.axis = UILayoutConstraintAxisVertical;
    self.contentStack.alignment = UIStackViewAlignmentFill;
    self.contentStack.spacing = appearance.spacing;
    self.contentStack.translatesAutoresizingMaskIntoConstraints = NO;

    [self.glassView.contentView addSubview:self.contentStack];

    [NSLayoutConstraint activateConstraints:@[
        [self.contentStack.topAnchor constraintEqualToAnchor:self.glassView.contentView.topAnchor constant:appearance.logoTopOffset],
        [self.contentStack.bottomAnchor constraintEqualToAnchor:self.glassView.contentView.bottomAnchor constant:-24.0],
        [self.contentStack.leadingAnchor constraintEqualToAnchor:self.glassView.contentView.leadingAnchor constant:24.0],
        [self.contentStack.trailingAnchor constraintEqualToAnchor:self.glassView.contentView.trailingAnchor constant:-24.0]
    ]];

    [self setupLogo];
    [self setupTitle:text.title];
    [self setupSubtitle:text.subtitle];
    [self setupSocialButtons];
    [self setupContinueButton];

    if (self.config.appConfig.allowSkip) {
        [self setupDontShowAgain:text.dontShowAgain];
    }
}

#pragma mark - Logo

- (void)setupLogo {

    AppearanceConfig *appearance = self.config.appearanceConfig;

    self.logoView = [[UIImageView alloc] init];
    self.logoView.translatesAutoresizingMaskIntoConstraints = NO;
    self.logoView.contentMode = UIViewContentModeScaleAspectFit;
    self.logoView.clipsToBounds = YES;
    self.logoView.layer.cornerRadius = 24.0;

    UIImage *logo =
    [UIImage imageNamed:@"GeraKStoreWelcome.png"];

    if (!logo) {
        logo = [UIImage imageNamed:@"GeraKStoreWelcome"];
    }

    if (!logo) {
        logo = [UIImage imageNamed:@"AppIcon"];
    }

    self.logoView.image = logo;

    [self.contentStack addArrangedSubview:self.logoView];

    [NSLayoutConstraint activateConstraints:@[
        [self.logoView.heightAnchor constraintEqualToConstant:appearance.logoSize],
        [self.logoView.widthAnchor constraintEqualToConstant:appearance.logoSize]
    ]];

    self.logoView.contentMode = UIViewContentModeScaleAspectFit;

    self.logoView.layer.shadowColor = UIColor.blackColor.CGColor;
    self.logoView.layer.shadowOpacity = 0.25;
    self.logoView.layer.shadowRadius = 16.0;
    self.logoView.layer.shadowOffset = CGSizeMake(0, 8);
}

#pragma mark - Title

- (void)setupTitle:(NSString *)title {

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;

    self.titleLabel.text = title;
    self.titleLabel.textColor =
    [self colorFromHex:self.config.appearanceConfig.titleColor];
    self.titleLabel.font = [UIFont systemFontOfSize:30.0 weight:UIFontWeightBold];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;

    [self.contentStack addArrangedSubview:self.titleLabel];
}

#pragma mark - Subtitle

- (void)setupSubtitle:(NSString *)subtitle {

    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;

    self.subtitleLabel.text = subtitle;
    self.subtitleLabel.textColor =
    [self colorFromHex:self.config.appearanceConfig.subtitleColor];

    self.subtitleLabel.font =
    [UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular];

    self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subtitleLabel.numberOfLines = 0;

    [self.contentStack addArrangedSubview:self.subtitleLabel];
}

#pragma mark - Social Buttons

- (void)setupSocialButtons {

    TextConfig *text = self.config.textConfig;

    UIStackView *socialStack =
    [[UIStackView alloc] init];

    socialStack.axis = UILayoutConstraintAxisHorizontal;
    socialStack.spacing = 12.0;
    socialStack.distribution = UIStackViewDistributionFillEqually;

    self.telegramButton =
    [self createGlassButtonWithTitle:text.telegramButton];

    self.githubButton =
    [self createGlassButtonWithTitle:text.githubButton];

    [socialStack addArrangedSubview:self.telegramButton];
    [socialStack addArrangedSubview:self.githubButton];

    [self.contentStack addArrangedSubview:socialStack];

    [NSLayoutConstraint activateConstraints:@[
        [socialStack.heightAnchor constraintEqualToConstant:44.0]
    ]];
}

#pragma mark - Continue

- (void)setupContinueButton {

    TextConfig *text = self.config.textConfig;
    AppearanceConfig *appearance = self.config.appearanceConfig;

    self.continueButton =
    [self createPrimaryButtonWithTitle:text.continueButton
                               colors:appearance.primaryGradient];

    [self.contentStack addArrangedSubview:self.continueButton];

    [NSLayoutConstraint activateConstraints:@[
        [self.continueButton.heightAnchor
         constraintEqualToConstant:appearance.buttonHeight]
    ]];
}

#pragma mark - Don't Show Again

- (void)setupDontShowAgain:(NSString *)title {

    self.dontShowAgainButton =
    [UIButton buttonWithType:UIButtonTypeSystem];

    self.dontShowAgainButton.translatesAutoresizingMaskIntoConstraints = NO;

    [self.dontShowAgainButton setTitle:title
                              forState:UIControlStateNormal];

    [self.dontShowAgainButton setTitleColor:
     [UIColor.whiteColor colorWithAlphaComponent:0.55]
                                   forState:UIControlStateNormal];

    self.dontShowAgainButton.titleLabel.font =
    [UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium];

    [self.contentStack addArrangedSubview:self.dontShowAgainButton];

    [NSLayoutConstraint activateConstraints:@[
        [self.dontShowAgainButton.heightAnchor
         constraintEqualToConstant:30.0]
    ]];
}

#pragma mark - Buttons

- (UIButton *)createGlassButtonWithTitle:(NSString *)title {

    UIButton *button =
    [UIButton buttonWithType:UIButtonTypeSystem];

    button.translatesAutoresizingMaskIntoConstraints = NO;

    [button setTitle:title forState:UIControlStateNormal];

    [button setTitleColor:
     UIColor.whiteColor
                forState:UIControlStateNormal];

    button.titleLabel.font =
    [UIFont systemFontOfSize:15.0 weight:UIFontWeightSemibold];

    button.backgroundColor =
    [UIColor.whiteColor colorWithAlphaComponent:0.10];

    button.layer.cornerRadius = 16.0;

    button.layer.borderWidth = 1.0;

    button.layer.borderColor =
    [UIColor.whiteColor colorWithAlphaComponent:0.12].CGColor;

    return button;
}

- (UIButton *)createPrimaryButtonWithTitle:(NSString *)title
                                    colors:(NSArray<NSString *> *)colors {

    UIButton *button =
    [UIButton buttonWithType:UIButtonTypeSystem];

    button.translatesAutoresizingMaskIntoConstraints = NO;

    [button setTitle:title forState:UIControlStateNormal];

    [button setTitleColor:UIColor.whiteColor
                forState:UIControlStateNormal];

    button.titleLabel.font =
    [UIFont systemFontOfSize:17.0 weight:UIFontWeightBold];

    button.layer.cornerRadius = 18.0;

    CAGradientLayer *gradient =
    [CAGradientLayer layer];

    NSMutableArray *cgColors = [NSMutableArray array];

    for (NSString *hex in colors) {

        UIColor *color = [self colorFromHex:hex];

        if (color) {
            [cgColors addObject:(id)color.CGColor];
        }
    }

    if (cgColors.count > 0) {
        gradient.colors = cgColors;
    }

    gradient.startPoint = CGPointMake(0.0, 0.5);
    gradient.endPoint = CGPointMake(1.0, 0.5);

    self.continueGradientLayer = gradient;

    [button.layer insertSublayer:gradient atIndex:0];

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

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dontShowAgainPressed {

    [UserDefaultsWelcome markWelcomeAsSeen];

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - URL

- (void)openURLString:(NSString *)string {

    if (string.length == 0) return;

    NSURL *url =
    [NSURL URLWithString:string];

    if (!url) return;

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

    self.glassView.alpha = 0.0;
    self.glassView.transform =
    CGAffineTransformMakeScale(0.94, 0.94);

    [UIView animateWithDuration:0.45
                          delay:0.05
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{

        self.glassView.alpha = 1.0;
        self.glassView.transform =
        CGAffineTransformIdentity;

    } completion:nil];
}

#pragma mark - Colors

- (UIColor *)colorFromHex:(NSString *)hex {

    if (![hex isKindOfClass:[NSString class]]) {
        return nil;
    }

    NSString *clean =
    [[hex stringByReplacingOccurrencesOfString:@"#" withString:@""]
     uppercaseString];

    if (clean.length != 6 && clean.length != 8) {
        return nil;
    }

    unsigned int value = 0;

    NSScanner *scanner =
    [NSScanner scannerWithString:clean];

    if (![scanner scanHexInt:&value]) {
        return nil;
    }

    CGFloat r;
    CGFloat g;
    CGFloat b;
    CGFloat a = 1.0;

    if (clean.length == 8) {

        r = ((value >> 24) & 0xFF) / 255.0;
        g = ((value >> 16) & 0xFF) / 255.0;
        b = ((value >> 8) & 0xFF) / 255.0;
        a = (value & 0xFF) / 255.0;

    } else {

        r = ((value >> 16) & 0xFF) / 255.0;
        g = ((value >> 8) & 0xFF) / 255.0;
        b = (value & 0xFF) / 255.0;
    }

    return [UIColor colorWithRed:r
                           green:g
                            blue:b
                           alpha:a];
}

@end
