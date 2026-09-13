#import "WelcomeViewController.h"
#import "WelcomeConfig.h"
#import "WelcomeAssets.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface WelcomeViewController ()
@property (nonatomic, strong) UIView *sceneContainer;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) CAGradientLayer *vignetteLayer;
@property (nonatomic, strong) CAEmitterLayer *particleEmitter;

@property (nonatomic, strong) UIView *plaquesLayer;
@property (nonatomic, strong) UIView *headerInfoLayer;
@property (nonatomic, strong) UIView *bottomActionsLayer;

@property (nonatomic, strong) UIImageView *metalLogoView;
@property (nonatomic, strong) CAGradientLayer *shimmerLayer;
@property (nonatomic, strong) UIView *leftPlaqueView;
@property (nonatomic, strong) UIView *rightPlaqueView;

@property (nonatomic, assign) BOOL heartbeatActive;
@property (nonatomic, strong) UIImpactFeedbackGenerator *heavyFeedback;
@property (nonatomic, strong) UIImpactFeedbackGenerator *lightFeedback;
@end

@implementation WelcomeViewController

#pragma mark - Хелперы декодирования и графики

- (UIImage *)imageFromBase64:(NSString *)base64String {
    if (!base64String || base64String.length == 0) return nil;
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    if (!data) return nil;
    return [UIImage imageWithData:data];
}

- (UIImage *)removeBlackBackground:(UIImage *)image {
    if (!image) return nil;
    CGImageRef rawRef = image.CGImage;
    if (!rawRef) return image;
    
    const CGFloat maskColors[6] = {0, 30, 0, 30, 0, 30};
    CGImageRef maskedRef = CGImageCreateWithMaskingColors(rawRef, maskColors);
    if (!maskedRef) return image;
    
    UIImage *cleanImage = [UIImage imageWithCGImage:maskedRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(maskedRef);
    return cleanImage ?: image;
}

- (UIImage *)extractSinglePlaque:(UIImage *)sourceImage {
    if (!sourceImage) return nil;
    CGImageRef cgImg = sourceImage.CGImage;
    if (!cgImg) return sourceImage;
    
    size_t fullW = CGImageGetWidth(cgImg);
    size_t fullH = CGImageGetHeight(cgImg);
    if (fullW == 0 || fullH == 0) return sourceImage;
    
    CGRect cropRect = CGRectMake(0, 0, (CGFloat)fullW * 0.48, (CGFloat)fullH);
    CGImageRef croppedRef = CGImageCreateWithImageInRect(cgImg, cropRect);
    if (!croppedRef) return sourceImage;
    
    UIImage *plaque = [UIImage imageWithCGImage:croppedRef scale:sourceImage.scale orientation:sourceImage.imageOrientation];
    CGImageRelease(croppedRef);
    return plaque ?: sourceImage;
}

- (UIImage *)generateParticleDotImage {
    CGSize size = CGSizeMake(8, 8);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:1.0 green:0.86 blue:0.60 alpha:0.9].CGColor);
    CGContextFillEllipseInRect(ctx, CGRectMake(0, 0, size.width, size.height));
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - Жизненный цикл

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.modalInPresentation = YES;

    self.heavyFeedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
    self.lightFeedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [self.heavyFeedback prepare];
    [self.lightFeedback prepare];

    self.sceneContainer = [[UIView alloc] initWithFrame:CGRectInset(self.view.bounds, -45, -45)];
    self.sceneContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.sceneContainer];

    [self setupBackground];
    [self setupVignetteAndParticles];
    [self setupHeaderInfo];
    [self setupPlaques];
    [self setupBottomActions];
    [self applyMultiDepthParallax];

    [self prepareInitialEntryStates];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self startKenBurnsEffect];

    [self executeEntranceChoreographyWithCompletion:^{
        if ([WelcomeConfig sharedConfig].pulseEnabled) {
            [self startHeartbeatCycle];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopHeartbeatCycle];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.vignetteLayer) {
        self.vignetteLayer.frame = self.view.bounds;
    }
}

#pragma mark - Настройка сцены

- (void)setupBackground {
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.sceneContainer.bounds];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.clipsToBounds = YES;
    self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    UIImage *bg = [self imageFromBase64:kWelcomeBackgroundBase64] ?: [UIImage imageNamed:@"welcome_bg.jpg"];
    self.backgroundImageView.image = bg;
    [self.sceneContainer addSubview:self.backgroundImageView];
}

- (void)setupVignetteAndParticles {
    self.vignetteLayer = [CAGradientLayer layer];
    self.vignetteLayer.type = kCAGradientLayerRadial;
    self.vignetteLayer.colors = @[
        (id)[UIColor clearColor].CGColor,
        (id)[UIColor colorWithWhite:0.0 alpha:0.30].CGColor,
        (id)[UIColor colorWithWhite:0.0 alpha:0.75].CGColor
    ];
    self.vignetteLayer.locations = @[@0.0, @0.62, @1.0];
    self.vignetteLayer.startPoint = CGPointMake(0.5, 0.5);
    self.vignetteLayer.endPoint = CGPointMake(1.0, 1.0);
    self.vignetteLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:self.vignetteLayer above:self.sceneContainer.layer];

    self.particleEmitter = [CAEmitterLayer layer];
    self.particleEmitter.emitterPosition = CGPointMake(self.view.bounds.size.width / 2.0, -20);
    self.particleEmitter.emitterSize = CGSizeMake(self.view.bounds.size.width * 1.2, 10);
    self.particleEmitter.emitterShape = kCAEmitterLayerLine;

    CAEmitterCell *sparkle = [CAEmitterCell emitterCell];
    sparkle.birthRate = 6.0;
    sparkle.lifetime = 14.0;
    sparkle.velocity = 22.0;
    sparkle.velocityRange = 10.0;
    sparkle.emissionLongitude = (CGFloat)M_PI;
    sparkle.emissionRange = (CGFloat)(M_PI / 4.0);
    sparkle.scale = 0.40;
    sparkle.scaleRange = 0.20;
    sparkle.alphaRange = 0.5;
    sparkle.alphaSpeed = -0.06;
    sparkle.spin = 0.4;
    sparkle.spinRange = 0.8;
    sparkle.contents = (id)[self generateParticleDotImage].CGImage;

    self.particleEmitter.emitterCells = @[sparkle];
    [self.sceneContainer.layer addSublayer:self.particleEmitter];
}

- (void)setupHeaderInfo {
    WelcomeConfig *cfg = [WelcomeConfig sharedConfig];
    CGFloat screenW = self.view.bounds.size.width;
    CGFloat screenH = self.view.bounds.size.height;

    CGFloat headerW = screenW - 160;
    CGFloat headerH = 240;
    CGFloat startY = screenH * 0.38;

    self.headerInfoLayer = [[UIView alloc] initWithFrame:CGRectMake((screenW - headerW) / 2.0 + 45, startY + 45, headerW, headerH)];
    [self.sceneContainer addSubview:self.headerInfoLayer];

    // Стеклянная подложка
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *glassView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    glassView.frame = CGRectMake(0, 95, headerW, 120);
    glassView.layer.cornerRadius = 20.0;
    glassView.layer.borderWidth = 0.8;
    glassView.layer.borderColor = [UIColor colorWithRed:0.92 green:0.82 blue:0.65 alpha:0.45].CGColor;
    glassView.clipsToBounds = YES;
    glassView.backgroundColor = [UIColor colorWithRed:0.10 green:0.07 blue:0.05 alpha:0.25];
    [self.headerInfoLayer addSubview:glassView];

    UIImage *rawLogo = [self imageFromBase64:kStoreLogoBase64] ?: [UIImage imageNamed:@"store_logo.png"];
    UIImage *cleanLogo = [self removeBlackBackground:rawLogo];

    CGFloat logoW = 230.0;
    CGFloat logoH = 115.0;
    // Поднимаем логотип до Y = -24, чтобы он не наползал на плашку и заголовок
    self.metalLogoView = [[UIImageView alloc] initWithFrame:CGRectMake((headerW - logoW) / 2.0, -24, logoW, logoH)];
    self.metalLogoView.contentMode = UIViewContentModeScaleAspectFit;
    self.metalLogoView.image = cleanLogo;
    self.metalLogoView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.metalLogoView.layer.shadowOpacity = 0.70;
    self.metalLogoView.layer.shadowRadius = 18.0;
    self.metalLogoView.layer.shadowOffset = CGSizeMake(0, 10);
    [self.headerInfoLayer addSubview:self.metalLogoView];

    [self setupLogoShimmerEffect];

    // Центрируем текст внутри высоты плашки (Y: 95 до 215)
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(8, 110, headerW - 16, 28)];
    title.text = cfg.headlineText;
    title.textAlignment = NSTextAlignmentCenter;
    UIFont *serifFont = [UIFont fontWithName:@"Georgia-Bold" size:22.0];
    if (!serifFont) serifFont = [UIFont boldSystemFontOfSize:21.5];
    title.font = serifFont;
    title.textColor = [UIColor colorWithRed:0.98 green:0.96 blue:0.93 alpha:1.0];
    title.layer.shadowColor = [UIColor blackColor].CGColor;
    title.layer.shadowOpacity = 0.60;
    title.layer.shadowRadius = 3.0;
    title.layer.shadowOffset = CGSizeMake(0, 1.5);
    [self.headerInfoLayer addSubview:title];

    UILabel *subLine1 = [[UILabel alloc] initWithFrame:CGRectMake(8, 144, headerW - 16, 18)];
    subLine1.text = cfg.sublineText;
    subLine1.textAlignment = NSTextAlignmentCenter;
    subLine1.font = [UIFont systemFontOfSize:12.5 weight:UIFontWeightMedium];
    subLine1.textColor = [UIColor colorWithRed:0.88 green:0.83 blue:0.75 alpha:0.90];
    [self.headerInfoLayer addSubview:subLine1];

    UILabel *subLine2 = [[UILabel alloc] initWithFrame:CGRectMake(8, 168, headerW - 16, 22)];
    subLine2.text = cfg.storeSubtitleText;
    subLine2.textAlignment = NSTextAlignmentCenter;
    UIFont *storeFont = [UIFont fontWithName:@"Georgia-Medium" size:15.5];
    if (!storeFont) storeFont = [UIFont systemFontOfSize:15.5 weight:UIFontWeightSemibold];
    subLine2.font = storeFont;
    subLine2.textColor = [UIColor colorWithRed:0.95 green:0.86 blue:0.70 alpha:1.0];
    subLine2.layer.shadowColor = [UIColor blackColor].CGColor;
    subLine2.layer.shadowOpacity = 0.50;
    subLine2.layer.shadowRadius = 2.0;
    subLine2.layer.shadowOffset = CGSizeMake(0, 1.0);
    [self.headerInfoLayer addSubview:subLine2];
}

- (void)setupPlaques {
    WelcomeConfig *cfg = [WelcomeConfig sharedConfig];
    CGFloat screenW = self.view.bounds.size.width;
    CGFloat screenH = self.view.bounds.size.height;

    self.plaquesLayer = [[UIView alloc] initWithFrame:self.sceneContainer.bounds];
    [self.sceneContainer addSubview:self.plaquesLayer];

    UIImage *rawPlaques = [self imageFromBase64:kPlaquesBase64] ?: [UIImage imageNamed:@"plaques.png"];
    UIImage *singlePlaque = [self extractSinglePlaque:rawPlaques];

    // Выравниваем центр дощечек строго по центру стеклянной плашки
    CGFloat cardCenterY = (screenH * 0.38) + 95 + 60; // startY + отступ плашки + половина высоты
    CGFloat plaqueY = cardCenterY - (cfg.plaqueSize.height / 2.0) + 45;

    CGFloat leftX = cfg.leftPlaqueOrigin.x + 45;
    self.leftPlaqueView = [self buildPlaqueViewWithImage:singlePlaque
                                                   text:cfg.leftPlaqueText
                                                  frame:CGRectMake(leftX, plaqueY, cfg.plaqueSize.width, cfg.plaqueSize.height)
                                                isRight:NO];
    [self.plaquesLayer addSubview:self.leftPlaqueView];

    CGFloat rightX = screenW - cfg.rightPlaqueOrigin.x - cfg.plaqueSize.width + 45;
    self.rightPlaqueView = [self buildPlaqueViewWithImage:singlePlaque
                                                    text:cfg.rightPlaqueText
                                                   frame:CGRectMake(rightX, plaqueY, cfg.plaqueSize.width, cfg.plaqueSize.height)
                                                 isRight:YES];
    [self.plaquesLayer addSubview:self.rightPlaqueView];
}

- (UIView *)buildPlaqueViewWithImage:(UIImage *)plaqueImage text:(NSString *)text frame:(CGRect)frame isRight:(BOOL)isRight {
    UIView *container = [[UIView alloc] initWithFrame:frame];

    UIImageView *plaqueBg = [[UIImageView alloc] initWithFrame:container.bounds];
    plaqueBg.contentMode = UIViewContentModeScaleToFill;
    plaqueBg.image = plaqueImage;
    plaqueBg.layer.shadowColor = [UIColor blackColor].CGColor;
    plaqueBg.layer.shadowOpacity = 0.65;
    plaqueBg.layer.shadowRadius = 14.0;
    plaqueBg.layer.shadowOffset = CGSizeMake(isRight ? -5 : 5, 9);
    [container addSubview:plaqueBg];

    CGFloat topPadding = 32.0;
    CGFloat bottomPadding = 30.0;
    CGFloat innerW = frame.size.width - 12.0;
    CGFloat innerH = frame.size.height - topPadding - bottomPadding;

    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(6.0, topPadding, innerW, innerH)];
    lbl.text = text;
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.numberOfLines = 0;
    lbl.font = [UIFont systemFontOfSize:18 weight:UIFontWeightHeavy];
    lbl.textColor = [UIColor colorWithRed:0.20 green:0.11 blue:0.06 alpha:0.98];
    
    lbl.layer.shadowColor = [UIColor colorWithRed:0.98 green:0.93 blue:0.86 alpha:0.85].CGColor;
    lbl.layer.shadowOpacity = 1.0;
    lbl.layer.shadowRadius = 0.6;
    lbl.layer.shadowOffset = CGSizeMake(0, 1.0);
    [container addSubview:lbl];

    return container;
}

- (void)setupLogoShimmerEffect {
    self.shimmerLayer = [CAGradientLayer layer];
    self.shimmerLayer.frame = self.metalLogoView.bounds;
    self.shimmerLayer.startPoint = CGPointMake(0.0, 0.5);
    self.shimmerLayer.endPoint = CGPointMake(1.0, 0.5);
    self.shimmerLayer.colors = @[
        (id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor,
        (id)[UIColor colorWithRed:1.0 green:0.92 blue:0.75 alpha:0.50].CGColor,
        (id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor
    ];
    self.shimmerLayer.locations = @[@0.0, @0.1, @0.2];
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.contents = (id)self.metalLogoView.image.CGImage;
    maskLayer.frame = self.metalLogoView.bounds;
    maskLayer.contentsGravity = kCAGravityResizeAspect;
    self.shimmerLayer.mask = maskLayer;
    
    [self.metalLogoView.layer addSublayer:self.shimmerLayer];
    self.shimmerLayer.opacity = 0.0;
}

- (void)triggerShimmerSweep {
    self.shimmerLayer.opacity = 1.0;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
    animation.fromValue = @[@0.0, @0.05, @0.15];
    animation.toValue = @[@0.85, @0.95, @1.0];
    animation.duration = 0.65;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.shimmerLayer addAnimation:animation forKey:@"welcome.japan.shimmerSweep"];
}

- (void)setupBottomActions {
    WelcomeConfig *cfg = [WelcomeConfig sharedConfig];
    CGFloat screenW = self.view.bounds.size.width;
    CGFloat screenH = self.view.bounds.size.height;

    CGFloat actionsW = screenW - 80;
    CGFloat actionsH = 160;
    // Кнопки зафиксированы на исходной нижней позиции
    CGFloat bottomY = screenH * 0.77;

    self.bottomActionsLayer = [[UIView alloc] initWithFrame:CGRectMake((screenW - actionsW) / 2.0 + 45, bottomY + 45, actionsW, actionsH)];
    [self.sceneContainer addSubview:self.bottomActionsLayer];

    CGFloat btnSpacing = 12.0;
    CGFloat btnW = (actionsW - btnSpacing) / 2.0;
    
    UIButton *tgBtn = [self createThemeButton:@"Telegram" frame:CGRectMake(0, 0, btnW, 46)];
    [tgBtn addTarget:self action:@selector(openTelegram) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomActionsLayer addSubview:tgBtn];

    UIButton *ghBtn = [self createThemeButton:@"GitHub" frame:CGRectMake(btnW + btnSpacing, 0, btnW, 46)];
    [ghBtn addTarget:self action:@selector(openGithub) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomActionsLayer addSubview:ghBtn];

    UIButton *contBtn = [self createThemeButton:cfg.continueButtonText frame:CGRectMake(0, 56, actionsW, 48)];
    [contBtn addTarget:self action:@selector(dismissScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomActionsLayer addSubview:contBtn];

    // Предельно незаметная кнопка «Больше не показывать»
    UIButton *neverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    neverBtn.frame = CGRectMake(0, 116, actionsW, 22);
    
    NSAttributedString *attrNever = [[NSAttributedString alloc] initWithString:cfg.neverShowText attributes:@{
        NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0 alpha:0.35],
        NSFontAttributeName: [UIFont systemFontOfSize:11.5 weight:UIFontWeightRegular]
    }];
    [neverBtn setAttributedTitle:attrNever forState:UIControlStateNormal];
    [neverBtn addTarget:self action:@selector(neverShowAgain) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomActionsLayer addSubview:neverBtn];
}

- (UIButton *)createThemeButton:(NSString *)title frame:(CGRect)frame {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.tintColor = [UIColor colorWithRed:0.98 green:0.96 blue:0.92 alpha:1.0];
    btn.backgroundColor = [UIColor colorWithRed:0.12 green:0.09 blue:0.07 alpha:0.75];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor blackColor];
    shadow.shadowBlurRadius = 2.0;
    shadow.shadowOffset = CGSizeMake(0, 1.0);
    
    NSDictionary *normalAttrs = @{
        NSForegroundColorAttributeName: [UIColor colorWithRed:0.98 green:0.96 blue:0.92 alpha:1.0],
        NSFontAttributeName: [UIFont boldSystemFontOfSize:15.5],
        NSShadowAttributeName: shadow
    };
    [btn setAttributedTitle:[[NSAttributedString alloc] initWithString:title attributes:normalAttrs] forState:UIControlStateNormal];
    
    NSDictionary *highlightAttrs = @{
        NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0 alpha:0.6],
        NSFontAttributeName: [UIFont boldSystemFontOfSize:15.5],
        NSShadowAttributeName: shadow
    };
    [btn setAttributedTitle:[[NSAttributedString alloc] initWithString:title attributes:highlightAttrs] forState:UIControlStateHighlighted];
    
    btn.layer.cornerRadius = 14.0;
    btn.layer.borderWidth = 0.8;
    btn.layer.borderColor = [UIColor colorWithRed:0.88 green:0.78 blue:0.62 alpha:0.45].CGColor;
    
    btn.layer.shadowColor = [UIColor blackColor].CGColor;
    btn.layer.shadowOpacity = 0.40;
    btn.layer.shadowRadius = 8.0;
    btn.layer.shadowOffset = CGSizeMake(0, 4);
    
    [btn addTarget:self action:@selector(buttonTouchHaptic) forControlEvents:UIControlEventTouchDown];
    return btn;
}

- (void)buttonTouchHaptic {
    [self.heavyFeedback prepare];
    if (@available(iOS 13.0, *)) {
        [self.heavyFeedback impactOccurredWithIntensity:1.0];
    } else {
        [self.heavyFeedback impactOccurred];
    }
}

#pragma mark - Кинематографический зум & Хореография

- (void)startKenBurnsEffect {
    [UIView animateWithDuration:18.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
        self.backgroundImageView.transform = CGAffineTransformMakeScale(1.08, 1.08);
    } completion:nil];
}

- (void)prepareInitialEntryStates {
    self.backgroundImageView.alpha = 0.0;
    self.vignetteLayer.opacity = 0.0;
    
    self.leftPlaqueView.transform = CGAffineTransformMakeTranslation(0, -60);
    self.leftPlaqueView.alpha = 0.0;

    self.rightPlaqueView.transform = CGAffineTransformMakeTranslation(0, -60);
    self.rightPlaqueView.alpha = 0.0;

    self.headerInfoLayer.transform = CGAffineTransformMakeScale(0.90, 0.90);
    self.headerInfoLayer.alpha = 0.0;

    self.bottomActionsLayer.transform = CGAffineTransformMakeTranslation(0, 45);
    self.bottomActionsLayer.alpha = 0.0;
}

- (void)executeEntranceChoreographyWithCompletion:(void(^)(void))completion {
    [UIView animateWithDuration:0.85 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backgroundImageView.alpha = 1.0;
        self.vignetteLayer.opacity = 1.0;
    } completion:nil];

    [UIView animateWithDuration:1.1 delay:0.15 usingSpringWithDamping:0.80 initialSpringVelocity:0.4 options:0 animations:^{
        self.leftPlaqueView.transform = CGAffineTransformIdentity;
        self.leftPlaqueView.alpha = 1.0;
        self.rightPlaqueView.transform = CGAffineTransformIdentity;
        self.rightPlaqueView.alpha = 1.0;
    } completion:nil];

    [UIView animateWithDuration:1.0 delay:0.28 usingSpringWithDamping:0.75 initialSpringVelocity:0.6 options:0 animations:^{
        self.headerInfoLayer.transform = CGAffineTransformIdentity;
        self.headerInfoLayer.alpha = 1.0;
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];

    [UIView animateWithDuration:0.9 delay:0.40 usingSpringWithDamping:0.85 initialSpringVelocity:0.3 options:0 animations:^{
        self.bottomActionsLayer.transform = CGAffineTransformIdentity;
        self.bottomActionsLayer.alpha = 1.0;
    } completion:nil];
}

#pragma mark - Усиленный тактовый кардио-движок + Блик

- (void)startHeartbeatCycle {
    if (self.heartbeatActive) return;
    self.heartbeatActive = YES;
    [self performSynchronizedPulseStep];
}

- (void)performSynchronizedPulseStep {
    if (!self.heartbeatActive) return;

    CAKeyframeAnimation *pulse = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    pulse.values = @[@1.0, @1.08, @1.02, @1.05, @1.0];
    pulse.keyTimes = @[@0.0, @0.10, @0.18, @0.28, @1.0];
    pulse.duration = 1.25;
    pulse.removedOnCompletion = YES;
    pulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.metalLogoView.layer addAnimation:pulse forKey:@"welcome.japan.singleBeat"];

    [self triggerShimmerSweep];

    [self.heavyFeedback prepare];
    if (@available(iOS 13.0, *)) {
        [self.heavyFeedback impactOccurredWithIntensity:1.0];
    } else {
        [self.heavyFeedback impactOccurred];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.13 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.heartbeatActive) return;
        [self.lightFeedback prepare];
        if (@available(iOS 13.0, *)) {
            [self.lightFeedback impactOccurredWithIntensity:0.85];
        } else {
            [self.lightFeedback impactOccurred];
        }
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.heartbeatActive) return;
        [self.heavyFeedback prepare];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.heartbeatActive) {
            [self performSynchronizedPulseStep];
        }
    });
}

- (void)stopHeartbeatCycle {
    self.heartbeatActive = NO;
    [self.metalLogoView.layer removeAnimationForKey:@"welcome.japan.singleBeat"];
    [self.shimmerLayer removeAnimationForKey:@"welcome.japan.shimmerSweep"];
}

- (void)addParallaxEffectToView:(UIView *)target depth:(CGFloat)depth {
    UIInterpolatingMotionEffect *x = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    x.minimumRelativeValue = @(-depth);
    x.maximumRelativeValue = @(depth);

    UIInterpolatingMotionEffect *y = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    y.minimumRelativeValue = @(-depth);
    y.maximumRelativeValue = @(depth);

    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[x, y];
    [target addMotionEffect:group];
}

- (void)applyMultiDepthParallax {
    WelcomeConfig *cfg = [WelcomeConfig sharedConfig];
    [self addParallaxEffectToView:self.backgroundImageView depth:6.0];
    [self addParallaxEffectToView:self.plaquesLayer depth:cfg.plaqueParallaxDepth];
    [self addParallaxEffectToView:self.headerInfoLayer depth:26.0];
    [self addParallaxEffectToView:self.metalLogoView depth:48.0];
    [self addParallaxEffectToView:self.bottomActionsLayer depth:20.0];
}

- (void)openTelegram {
    [self buttonTouchHaptic];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WelcomeConfig sharedConfig].telegramUrl] options:@{} completionHandler:nil];
}

- (void)openGithub {
    [self buttonTouchHaptic];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WelcomeConfig sharedConfig].githubUrl] options:@{} completionHandler:nil];
}

- (void)dismissScreen {
    [self buttonTouchHaptic];
    [self stopHeartbeatCycle];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)neverShowAgain {
    [self buttonTouchHaptic];
    [self stopHeartbeatCycle];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"com.gkuhtov.WelcomeToJapan.hasSeenWelcome"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
