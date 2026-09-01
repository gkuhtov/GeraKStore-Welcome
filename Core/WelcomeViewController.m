#import "EmbeddedResourceLoader.h"
#import <CoreMotion/CoreMotion.h>
#import "WelcomeViewController.h"
#import "WelcomeConfig.h"
#import "UserDefaults+Welcome.h"

@interface WelcomeViewController ()

@property (nonatomic, strong) CAGradientLayer *backgroundGradientLayer;
@property (nonatomic, strong) CALayer *backgroundGlowLayer;

@property (nonatomic, strong) CALayer *starsLayer;
@property (nonatomic, strong) CAShapeLayer *mountainsLayer;
@property (nonatomic, assign) BOOL ambientAnimationActive;

@property (nonatomic, strong) UIVisualEffectView *glassView;
@property (nonatomic, strong) UIView *glassTintView;

@property (nonatomic, strong) UIImageView *logoView;

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) CMAttitude *referenceAttitude;
@property (nonatomic, assign) BOOL motionActive;
@property (nonatomic, assign) CGFloat smoothedRoll;
@property (nonatomic, assign) CGFloat smoothedPitch;

@property (nonatomic, assign) CGFloat referenceRoll;
@property (nonatomic, assign) CGFloat referencePitch;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;

@property (nonatomic, strong) UIButton *telegramButton;
@property (nonatomic, strong) UIButton *githubButton;
@property (nonatomic, strong) UIButton *continueButton;
@property (nonatomic, strong) UIButton *dontShowAgainButton;

@property (nonatomic, strong) UIStackView *contentStack;
@property (nonatomic, strong) UIStackView *socialStack;

@property (nonatomic, strong) UIImpactFeedbackGenerator *heartbeatFeedback;
@property (nonatomic, assign) BOOL heartbeatActive;

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
    [self setupDecorations];
    [self setupGlass];
    [self setupInterface];
    [self setupActions];
    [self animateInterface];
    [self startAmbientAnimation];
    [self startMotionEffects];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    /*
     * Heartbeat запускаем после фактического
     * появления экрана.
     */

    [self startHeartbeat];

}

#pragma mark - Adaptive Layout

- (void)viewDidLayoutSubviews {

    [super viewDidLayoutSubviews];

    if (self.backgroundGlowLayer) {

        CGFloat size =
            MAX(self.view.bounds.size.width,
                self.view.bounds.size.height) * 0.72;

        self.backgroundGlowLayer.bounds =
            CGRectMake(
                0.0,
                0.0,
                size,
                size
            );

        self.backgroundGlowLayer.position =
            CGPointMake(
                self.view.bounds.size.width * 0.72,
                self.view.bounds.size.height * 0.28
            );
    }

    self.backgroundGradientLayer.frame =
        self.view.bounds;

    const CGFloat parallaxPadding =
        40.0;

    if (self.starsLayer) {

        self.starsLayer.frame =
            CGRectInset(
                self.view.bounds,
                -parallaxPadding,
                -parallaxPadding
            );

        [self layoutStars];
    }

    if (self.mountainsLayer) {

        self.mountainsLayer.frame =
            CGRectInset(
                self.view.bounds,
                -parallaxPadding,
                0.0
            );

        [self layoutMountains];
    }
}

- (void)layoutStars {

    if (!self.starsLayer) {
        return;
    }

    CGSize size =
        self.starsLayer.bounds.size;

    NSArray *positions = @[

        [NSValue valueWithCGPoint:
            CGPointMake(0.05, 0.08)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.14, 0.19)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.24, 0.07)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.34, 0.15)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.46, 0.06)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.58, 0.18)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.70, 0.08)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.83, 0.21)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.95, 0.11)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.08, 0.33)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.21, 0.42)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.36, 0.31)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.51, 0.40)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.65, 0.32)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.79, 0.43)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.92, 0.36)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.12, 0.54)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.29, 0.62)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.47, 0.55)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.63, 0.64)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.78, 0.56)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.93, 0.67)]
    ];

    NSUInteger count =
        MIN(
            positions.count,
            self.starsLayer.sublayers.count
        );

    for (NSUInteger i = 0; i < count; i++) {

        CALayer *star =
            (CALayer *)self.starsLayer.sublayers[i];

        CGPoint normalized =
            [positions[i] CGPointValue];

        star.position =
            CGPointMake(
                normalized.x * size.width,
                normalized.y * size.height
            );
    }
}

- (void)layoutMountains {

    if (!self.mountainsLayer) {
        return;
    }

    CGFloat width =
        self.mountainsLayer.bounds.size.width;

    CGFloat height =
        self.mountainsLayer.bounds.size.height;

    /*
     * Горы занимают нижнюю часть экрана.
     * Ширина слоя уже больше экрана,
     * поэтому при параллаксе края не появляются.
     */

    CGFloat mountainWidth =
        width;

    UIBezierPath *path =
        [UIBezierPath bezierPath];

    [path moveToPoint:
        CGPointMake(
            0.0,
            height * 0.88
        )];

    [path addLineToPoint:
        CGPointMake(
            mountainWidth * 0.07,
            height * 0.77
        )];

    [path addLineToPoint:
        CGPointMake(
            mountainWidth * 0.17,
            height * 0.86
        )];

    [path addLineToPoint:
        CGPointMake(
            mountainWidth * 0.29,
            height * 0.70
        )];

    [path addLineToPoint:
        CGPointMake(
            mountainWidth * 0.40,
            height * 0.83
        )];

    [path addLineToPoint:
        CGPointMake(
            mountainWidth * 0.53,
            height * 0.65
        )];

    [path addLineToPoint:
        CGPointMake(
            mountainWidth * 0.64,
            height * 0.81
        )];

    [path addLineToPoint:
        CGPointMake(
            mountainWidth * 0.76,
            height * 0.70
        )];

    [path addLineToPoint:
        CGPointMake(
            mountainWidth * 0.88,
            height * 0.84
        )];

    [path addLineToPoint:
        CGPointMake(
            mountainWidth,
            height * 0.75
        )];

    [path addLineToPoint:
        CGPointMake(
            mountainWidth,
            height
        )];

    [path addLineToPoint:
        CGPointMake(
            0.0,
            height
        )];

    [path closePath];

    self.mountainsLayer.path =
        path.CGPath;
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

    /*
     * Мягкое свечение за стеклом.
     * Оно будет двигаться вместе с параллаксом.
     */

    self.backgroundGlowLayer =
        [CALayer layer];

    self.backgroundGlowLayer.backgroundColor =
        [UIColor.whiteColor
            colorWithAlphaComponent:0.045].CGColor;

    self.backgroundGlowLayer.cornerRadius =
        180.0;

    self.backgroundGlowLayer.shadowColor =
        UIColor.whiteColor.CGColor;

    self.backgroundGlowLayer.shadowOpacity =
        0.20;

    self.backgroundGlowLayer.shadowRadius =
        90.0;

    self.backgroundGlowLayer.shadowOffset =
        CGSizeZero;

    [self.view.layer
        insertSublayer:self.backgroundGlowLayer
        above:self.backgroundGradientLayer];

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

#pragma mark - Decorations

- (void)setupDecorations {

    /*
     * Слои немного больше экрана.
     * Это оставляет запас для параллакса при наклоне телефона.
     */

    const CGFloat parallaxPadding =
        40.0;

    /*
     * Звёзды.
     */

    self.starsLayer =
        [CALayer layer];

    self.starsLayer.frame =
        CGRectInset(
            self.view.bounds,
            -parallaxPadding,
            -parallaxPadding
        );

    self.starsLayer.zPosition =
        1.0;

    [self.view.layer
        addSublayer:self.starsLayer];

    NSArray *starPositions = @[

        [NSValue valueWithCGPoint:
            CGPointMake(0.05, 0.08)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.14, 0.19)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.24, 0.07)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.34, 0.15)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.46, 0.06)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.58, 0.18)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.70, 0.08)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.83, 0.21)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.95, 0.11)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.08, 0.33)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.21, 0.42)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.36, 0.31)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.51, 0.40)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.65, 0.32)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.79, 0.43)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.92, 0.36)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.12, 0.54)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.29, 0.62)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.47, 0.55)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.63, 0.64)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.78, 0.56)],

        [NSValue valueWithCGPoint:
            CGPointMake(0.93, 0.67)]
    ];

    for (NSValue *value in starPositions) {

        CGPoint normalized =
            value.CGPointValue;

        CALayer *star =
            [CALayer layer];

        CGFloat seed =
            normalized.x * 17.0 +
            normalized.y * 31.0;

        CGFloat fraction =
            seed - floor(seed);

        CGFloat size =
            1.4 + fraction * 2.2;

        star.bounds =
            CGRectMake(
                0.0,
                0.0,
                size,
                size
            );

        star.cornerRadius =
            size / 2.0;

        star.backgroundColor =
            [UIColor.whiteColor
                colorWithAlphaComponent:0.72].CGColor;

        [self.starsLayer
            addSublayer:star];
    }

    /*
     * Горы.
     */

    self.mountainsLayer =
        [CAShapeLayer layer];

    self.mountainsLayer.frame =
        CGRectInset(
            self.view.bounds,
            -parallaxPadding,
            0.0
        );

    self.mountainsLayer.zPosition =
        2.0;

    self.mountainsLayer.fillColor =
        [UIColor.blackColor
            colorWithAlphaComponent:0.34].CGColor;

    [self.view.layer
        addSublayer:self.mountainsLayer];

    [self layoutStars];
    [self layoutMountains];
}

#pragma mark - Ambient Background

- (void)startAmbientAnimation {

    if (self.ambientAnimationActive ||
        !self.starsLayer) {
        return;
    }

    self.ambientAnimationActive = YES;

    /*
     * Очень медленное дыхание звёзд.
     * Работает на уровне Core Animation,
     * поэтому не нагружает главный поток.
     */

    CABasicAnimation *stars =
        [CABasicAnimation animationWithKeyPath:@"opacity"];

    stars.fromValue = @0.86;
    stars.toValue = @1.0;
    stars.duration = 3.2;
    stars.autoreverses = YES;
    stars.repeatCount = HUGE_VALF;

    stars.timingFunction =
        [CAMediaTimingFunction
            functionWithName:
                kCAMediaTimingFunctionEaseInEaseOut];

    [self.starsLayer
        addAnimation:stars
        forKey:@"gerastore.ambient.stars"];

    /*
     * Едва заметное дыхание гор.
     */

    if (self.mountainsLayer) {

        CABasicAnimation *mountains =
            [CABasicAnimation animationWithKeyPath:@"opacity"];

        mountains.fromValue = @0.94;
        mountains.toValue = @1.0;
        mountains.duration = 4.8;
        mountains.autoreverses = YES;
        mountains.repeatCount = HUGE_VALF;

        mountains.timingFunction =
            [CAMediaTimingFunction
                functionWithName:
                    kCAMediaTimingFunctionEaseInEaseOut];

        [self.mountainsLayer
            addAnimation:mountains
            forKey:@"gerastore.ambient.mountains"];
    }
}

- (void)stopAmbientAnimation {

    self.ambientAnimationActive = NO;

    [self.starsLayer
        removeAnimationForKey:
            @"gerastore.ambient.stars"];

    [self.mountainsLayer
        removeAnimationForKey:
            @"gerastore.ambient.mountains"];
}

#pragma mark - Motion

- (void)startMotionEffects {

    if (self.motionActive) {
        return;
    }

    CMMotionManager *manager =
        [[CMMotionManager alloc] init];

    if (!manager.deviceMotionAvailable) {
        return;
    }

    manager.deviceMotionUpdateInterval =
        1.0 / 60.0;

    self.motionManager =
        manager;

    self.motionActive =
        YES;

    self.smoothedRoll =
        0.0;

    self.smoothedPitch =
        0.0;

    NSOperationQueue *queue =
        [[NSOperationQueue alloc] init];

    queue.qualityOfService =
        NSQualityOfServiceUserInteractive;

    [manager startDeviceMotionUpdatesToQueue:queue
                                  withHandler:
        ^(CMDeviceMotion *motion, NSError *error) {

        if (error || !motion) {
            return;
        }

        CGFloat roll =
            (CGFloat)motion.attitude.roll;

        CGFloat pitch =
            (CGFloat)motion.attitude.pitch;

        roll =
            MAX(-0.70, MIN(0.70, roll));

        pitch =
            MAX(-0.70, MIN(0.70, pitch));

        dispatch_async(
            dispatch_get_main_queue(),
            ^{

                if (!self.motionActive) {
                    return;
                }

                /*
                 * Быстрое сглаживание.
                 * Параллакс реагирует сразу,
                 * но не дёргается.
                 */

                const CGFloat smoothing =
                    0.20;

                self.smoothedRoll +=
                    (roll - self.smoothedRoll)
                    * smoothing;

                self.smoothedPitch +=
                    (pitch - self.smoothedPitch)
                    * smoothing;

                CGFloat normalizedRoll =
                    self.smoothedRoll / 0.70;

                CGFloat normalizedPitch =
                    self.smoothedPitch / 0.70;

                /*
                 * Дальний слой.
                 * Движение максимально заметное.
                 */

                CATransform3D starsTransform =
                    CATransform3DIdentity;

                starsTransform.m34 =
                    -1.0 / 700.0;

                starsTransform =
                    CATransform3DTranslate(
                        starsTransform,
                        normalizedRoll * -70.0,
                        normalizedPitch * -52.0,
                        0.0
                    );

                starsTransform =
                    CATransform3DRotate(
                        starsTransform,
                        normalizedRoll * -0.055,
                        0.0,
                        0.0,
                        1.0
                    );

                self.starsLayer.transform =
                    starsTransform;

                /*
                 * Мягкое движение фонового свечения.
                 * Амплитуда меньше звёзд.
                 */

                CATransform3D glowTransform =
                    CATransform3DIdentity;

                glowTransform =
                    CATransform3DTranslate(
                        glowTransform,
                        normalizedRoll * -22.0,
                        normalizedPitch * -16.0,
                        0.0
                    );

                self.backgroundGlowLayer.transform =
                    glowTransform;

                /*
                 * Передний слой.
                 * Двигается слабее звёзд.
                 */

                CATransform3D mountainsTransform =
                    CATransform3DIdentity;

                mountainsTransform.m34 =
                    -1.0 / 900.0;

                mountainsTransform =
                    CATransform3DTranslate(
                        mountainsTransform,
                        normalizedRoll * -38.0,
                        normalizedPitch * -29.0,
                        0.0
                    );

                mountainsTransform =
                    CATransform3DRotate(
                        mountainsTransform,
                        normalizedRoll * -0.035,
                        0.0,
                        0.0,
                        1.0
                    );

                self.mountainsLayer.transform =
                    mountainsTransform;

                /*
                 * ЛОГОТИП.
                 *
                 * Очень лёгкий отдельный параллакс.
                 * Он меньше фоновых слоёв, поэтому
                 * логотип остаётся главным объектом.
                 */

                CATransform3D logoTransform =
                    CATransform3DIdentity;

                logoTransform.m34 =
                    -1.0 / 1000.0;

                logoTransform =
                    CATransform3DTranslate(
                        logoTransform,
                        normalizedRoll * -16.0,
                        normalizedPitch * -12.0,
                        0.0
                    );

                logoTransform =
                    CATransform3DRotate(
                        logoTransform,
                        normalizedRoll * -0.018,
                        0.0,
                        0.0,
                        1.0
                    );

                self.logoView.layer.transform =
                    logoTransform;
            }
        );
    }];
}

- (void)stopMotionEffects {

    self.heartbeatActive = NO;

    self.motionActive = NO;

    if (self.motionManager) {
        [self.motionManager stopDeviceMotionUpdates];
        self.motionManager = nil;
    }

    self.referenceAttitude =
        nil;

    [UIView animateWithDuration:0.25
                     animations:^{

        self.starsLayer.transform =
            CATransform3DIdentity;

        self.mountainsLayer.transform =
            CATransform3DIdentity;

        self.backgroundGlowLayer.transform =
            CATransform3DIdentity;
    }];
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
            constraintEqualToAnchor:
                self.view.leadingAnchor
                constant:16.0],

        [self.glassView.trailingAnchor
            constraintEqualToAnchor:
                self.view.trailingAnchor
                constant:-16.0],

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
                appearance.logoSize * 1.20]
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

        configuration.background.strokeColor =
            [UIColor.whiteColor
                colorWithAlphaComponent:0.38];

        configuration.background.strokeWidth =
            1.0;

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

        button.layer.borderWidth =
            1.0;

        button.layer.borderColor =
            [UIColor.whiteColor
                colorWithAlphaComponent:0.32].CGColor;

        button.layer.masksToBounds =
            YES;

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

    button.layer.shadowColor =
        UIColor.whiteColor.CGColor;

    button.layer.shadowOpacity =
        0.24;

    button.layer.shadowRadius =
        12.0;

    button.layer.shadowOffset =
        CGSizeZero;

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

        configuration.background.strokeColor =
            [UIColor.whiteColor
                colorWithAlphaComponent:0.38];

        configuration.background.strokeWidth =
            1.0;

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

        button.layer.borderWidth =
            1.0;

        button.layer.borderColor =
            [UIColor.whiteColor
                colorWithAlphaComponent:0.32].CGColor;

        button.layer.masksToBounds =
            YES;

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

    button.layer.shadowColor =
        UIColor.whiteColor.CGColor;

    button.layer.shadowOpacity =
        0.28;

    button.layer.shadowRadius =
        10.0;

    button.layer.shadowOffset =
        CGSizeZero;

    return button;
}


#pragma mark - Button Touch Animation

- (void)addButtonPressAnimation:(UIButton *)button {

    [button addTarget:self
               action:@selector(buttonTouchDown:)
     forControlEvents:UIControlEventTouchDown];

    [button addTarget:self
               action:@selector(buttonTouchUp:)
     forControlEvents:
        UIControlEventTouchUpInside |
        UIControlEventTouchUpOutside |
        UIControlEventTouchCancel];
}

- (void)buttonTouchDown:(UIButton *)button {

    [UIView animateWithDuration:
        0.10
        delay:0.0
        options:
            UIViewAnimationOptionBeginFromCurrentState |
            UIViewAnimationOptionCurveEaseOut
        animations:^{

            button.transform =
                CGAffineTransformMakeScale(
                    0.965,
                    0.965
                );

            button.alpha =
                0.82;

        }
        completion:nil];
}

- (void)buttonTouchUp:(UIButton *)button {

    [UIView animateWithDuration:
        0.22
        delay:0.0
        usingSpringWithDamping:0.62
        initialSpringVelocity:0.25
        options:
            UIViewAnimationOptionBeginFromCurrentState |
            UIViewAnimationOptionCurveEaseOut
        animations:^{

            button.transform =
                CGAffineTransformIdentity;

            button.alpha =
                1.0;

        }
        completion:nil];
}

#pragma mark - Actions

- (void)setupActions {

    NSArray *buttons = @[
        self.telegramButton,
        self.githubButton,
        self.continueButton,
        self.dontShowAgainButton
    ];

    for (UIButton *button in buttons) {
        [button addTarget:self
                   action:@selector(buttonTouchDown:)
         forControlEvents:UIControlEventTouchDown];

        [button addTarget:self
                   action:@selector(buttonTouchUp:)
         forControlEvents:
             UIControlEventTouchUpInside |
             UIControlEventTouchUpOutside |
             UIControlEventTouchCancel];
    }

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

    [self addButtonPressAnimation:self.telegramButton];
    [self addButtonPressAnimation:self.githubButton];
    [self addButtonPressAnimation:self.continueButton];
    [self addButtonPressAnimation:self.dontShowAgainButton];
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

    [self stopHeartbeat];
    [self stopAmbientAnimation];
    [self stopMotionEffects];

    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)dontShowAgainPressed {

    [self stopHeartbeat];
    [self stopAmbientAnimation];
    [self stopMotionEffects];

    [UserDefaultsWelcome
        markWelcomeAsSeen];

    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

#pragma mark - Heartbeat Stop

- (void)stopHeartbeat {

    self.heartbeatActive = NO;

    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    if (@available(iOS 10.0, *)) {
        self.heartbeatFeedback = nil;
    }

    [UIView animateWithDuration:0.12
                     animations:^{
        self.logoView.transform =
            CGAffineTransformIdentity;
    }];
}

#pragma mark - Button Interaction

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

    /*
     * Появление стеклянной карточки.
     */

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


#pragma mark - Heartbeat

- (void)startHeartbeat {

    if (self.heartbeatActive) {
        return;
    }

    if (!self.logoView) {
        return;
    }

    self.heartbeatActive =
        YES;

    if (@available(iOS 13.0, *)) {

        self.heartbeatFeedback =
            [[UIImpactFeedbackGenerator alloc]
                initWithStyle:
                    UIImpactFeedbackStyleHeavy];

        [self.heartbeatFeedback prepare];
    }

    [self performHeartbeatBeatOne];
}

- (void)performHeartbeatBeatOne {

    if (!self.heartbeatActive ||
        !self.logoView) {
        return;
    }

    /*
     * ТУК №1.
     * Основной сильный удар.
     */

    if (@available(iOS 13.0, *)) {

        self.heartbeatFeedback =
            [[UIImpactFeedbackGenerator alloc]
                initWithStyle:
                    UIImpactFeedbackStyleHeavy];

        [self.heartbeatFeedback prepare];

        [self.heartbeatFeedback impactOccurred];

        [self.heartbeatFeedback prepare];
    }

    [UIView animateWithDuration:
        0.115
        delay:0.0
        options:
            UIViewAnimationOptionAllowUserInteraction |
            UIViewAnimationOptionBeginFromCurrentState |
            UIViewAnimationOptionCurveEaseOut
        animations:^{

            self.logoView.transform =
                CGAffineTransformMakeScale(
                    1.15,
                    1.15
                );

        }
        completion:^(BOOL finished) {

            if (!self.heartbeatActive) {
                return;
            }

            [UIView animateWithDuration:
                0.16
                delay:0.0
                options:
                    UIViewAnimationOptionAllowUserInteraction |
                    UIViewAnimationOptionBeginFromCurrentState |
                    UIViewAnimationOptionCurveEaseInOut
                animations:^{

                    self.logoView.transform =
                        CGAffineTransformIdentity;

                }
                completion:^(BOOL finished) {

                    if (!self.heartbeatActive) {
                        return;
                    }

                    /*
                     * Короткий интервал
                     * между двумя ударами.
                     */

                    dispatch_after(
                        dispatch_time(
                            DISPATCH_TIME_NOW,
                            (int64_t)(
                                0.075 *
                                NSEC_PER_SEC
                            )
                        ),
                        dispatch_get_main_queue(),
                        ^{

                            if (self.heartbeatActive) {
                                [self performHeartbeatBeatTwo];
                            }

                        }
                    );
                }];
        }];
}

- (void)performHeartbeatBeatTwo {

    if (!self.heartbeatActive ||
        !self.logoView) {
        return;
    }

    /*
     * ТУК №2.
     * Второй удар немного слабее.
     */

    if (@available(iOS 13.0, *)) {

        self.heartbeatFeedback =
            [[UIImpactFeedbackGenerator alloc]
                initWithStyle:
                    UIImpactFeedbackStyleHeavy];

        [self.heartbeatFeedback prepare];

        [self.heartbeatFeedback impactOccurred];

        [self.heartbeatFeedback prepare];
    }

    [UIView animateWithDuration:
        0.095
        delay:0.0
        options:
            UIViewAnimationOptionAllowUserInteraction |
            UIViewAnimationOptionBeginFromCurrentState |
            UIViewAnimationOptionCurveEaseOut
        animations:^{

            self.logoView.transform =
                CGAffineTransformMakeScale(
                    1.095,
                    1.095
                );

        }
        completion:^(BOOL finished) {

            if (!self.heartbeatActive) {
                return;
            }

            [UIView animateWithDuration:
                0.145
                delay:0.0
                options:
                    UIViewAnimationOptionAllowUserInteraction |
                    UIViewAnimationOptionBeginFromCurrentState |
                    UIViewAnimationOptionCurveEaseInOut
                animations:^{

                    self.logoView.transform =
                        CGAffineTransformIdentity;

                }
                completion:^(BOOL finished) {

                    if (!self.heartbeatActive) {
                        return;
                    }

                    /*
                     * Пауза перед следующим
                     * сердцебиением.
                     */

                    dispatch_after(
                        dispatch_time(
                            DISPATCH_TIME_NOW,
                            (int64_t)(
                                0.82 *
                                NSEC_PER_SEC
                            )
                        ),
                        dispatch_get_main_queue(),
                        ^{

                            if (self.heartbeatActive) {
                                [self performHeartbeatBeatOne];
                            }

                        }
                    );
                }];
        }];
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
