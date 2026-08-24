#import "WelcomeViewController.h"
#import "WelcomeConfig.h"
#import "GlassCardView.h"
#import "URLOpener.h"
#import "UserDefaults+Welcome.h"

@interface WelcomeViewController ()

@property (nonatomic, strong) GlassCardView *cardView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIButton *telegramButton;
@property (nonatomic, strong) UIButton *githubButton;
@property (nonatomic, strong) UIButton *continueButton;
@property (nonatomic, strong) UIButton *dontShowButton;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupBackground];
    [self setupCard];
    [self setupLabels];
    [self setupButtons];
    [self setupConstraints];
}

#pragma mark - Setup

- (void)setupBackground {
    self.view.backgroundColor =
        [UIColor colorWithRed:0.04
                        green:0.04
                         blue:0.12
                        alpha:1.0];

    CAGradientLayer *gradient = [CAGradientLayer layer];

    gradient.frame = self.view.bounds;

    gradient.colors = @[
        (id)[UIColor colorWithRed:0.04
                            green:0.04
                             blue:0.12
                            alpha:1.0].CGColor,

        (id)[UIColor colorWithRed:0.10
                            green:0.04
                             blue:0.18
                            alpha:1.0].CGColor,

        (id)[UIColor colorWithRed:0.18
                            green:0.10
                             blue:0.30
                            alpha:1.0].CGColor
    ];

    gradient.locations = @[
        @0.0,
        @0.5,
        @1.0
    ];

    [self.view.layer insertSublayer:gradient atIndex:0];
}

- (void)setupCard {
    AppearanceConfig *app =
        [WelcomeConfig sharedConfig].appearanceConfig;

    self.cardView =
        [[GlassCardView alloc]
            initWithBlurRadius:app.glassBlurRadius
            opacity:app.glassOpacity
            cornerRadius:app.glassCornerRadius];

    self.cardView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.cardView];
}

- (void)setupLabels {
    TextConfig *text =
        [WelcomeConfig sharedConfig].textConfig;

    self.titleLabel = [[UILabel alloc] init];

    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.text = text.title;
    self.titleLabel.textColor = UIColor.whiteColor;
    self.titleLabel.font =
        [UIFont systemFontOfSize:28
                          weight:UIFontWeightBold];

    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;

    [self.cardView addSubview:self.titleLabel];

    self.subtitleLabel = [[UILabel alloc] init];

    self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.subtitleLabel.text = text.subtitle;

    self.subtitleLabel.textColor =
        [UIColor colorWithWhite:1.0 alpha:0.7];

    self.subtitleLabel.font =
        [UIFont systemFontOfSize:15
                          weight:UIFontWeightRegular];

    self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subtitleLabel.numberOfLines = 0;

    [self.cardView addSubview:self.subtitleLabel];
}

- (void)setupButtons {
    TextConfig *text =
        [WelcomeConfig sharedConfig].textConfig;

    self.telegramButton =
        [self createLinkButtonWithTitle:text.telegramButton];

    [self.telegramButton
        addTarget:self
        action:@selector(telegramTapped)
        forControlEvents:UIControlEventTouchUpInside];

    [self.cardView addSubview:self.telegramButton];

    self.githubButton =
        [self createLinkButtonWithTitle:text.githubButton];

    [self.githubButton
        addTarget:self
        action:@selector(githubTapped)
        forControlEvents:UIControlEventTouchUpInside];

    [self.cardView addSubview:self.githubButton];

    self.continueButton =
        [UIButton buttonWithType:UIButtonTypeSystem];

    self.continueButton.translatesAutoresizingMaskIntoConstraints = NO;

    [self.continueButton
        setTitle:text.continueButton
        forState:UIControlStateNormal];

    [self.continueButton
        setTitleColor:UIColor.whiteColor
        forState:UIControlStateNormal];

    self.continueButton.titleLabel.font =
        [UIFont systemFontOfSize:17
                          weight:UIFontWeightSemibold];

    self.continueButton.backgroundColor =
        [UIColor colorWithRed:1.0
                        green:0.31
                         blue:0.64
                        alpha:1.0];

    self.continueButton.layer.cornerRadius = 16.0;

    [self.continueButton
        addTarget:self
        action:@selector(continueTapped)
        forControlEvents:UIControlEventTouchUpInside];

    [self.cardView addSubview:self.continueButton];

    self.dontShowButton =
        [UIButton buttonWithType:UIButtonTypeSystem];

    self.dontShowButton.translatesAutoresizingMaskIntoConstraints = NO;

    [self.dontShowButton
        setTitle:text.dontShowAgain
        forState:UIControlStateNormal];

    [self.dontShowButton
        setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5]
        forState:UIControlStateNormal];

    self.dontShowButton.titleLabel.font =
        [UIFont systemFontOfSize:14
                          weight:UIFontWeightRegular];

    [self.dontShowButton
        addTarget:self
        action:@selector(dontShowTapped)
        forControlEvents:UIControlEventTouchUpInside];

    [self.cardView addSubview:self.dontShowButton];
}

- (UIButton *)createLinkButtonWithTitle:(NSString *)title {
    UIButton *button =
        [UIButton buttonWithType:UIButtonTypeSystem];

    button.translatesAutoresizingMaskIntoConstraints = NO;

    [button setTitle:title
            forState:UIControlStateNormal];

    [button setTitleColor:UIColor.whiteColor
                 forState:UIControlStateNormal];

    button.titleLabel.font =
        [UIFont systemFontOfSize:16
                          weight:UIFontWeightMedium];

    button.backgroundColor =
        [UIColor colorWithWhite:1.0 alpha:0.12];

    button.layer.cornerRadius = 14.0;
    button.layer.borderWidth = 0.8;

    button.layer.borderColor =
        [UIColor colorWithWhite:1.0 alpha:0.2].CGColor;

    return button;
}

#pragma mark - Constraints

- (void)setupConstraints {
    AppearanceConfig *app =
        [WelcomeConfig sharedConfig].appearanceConfig;

    [NSLayoutConstraint activateConstraints:@[
        [self.cardView.centerXAnchor
            constraintEqualToAnchor:self.view.centerXAnchor],

        [self.cardView.centerYAnchor
            constraintEqualToAnchor:self.view.centerYAnchor],

        [self.cardView.leadingAnchor
            constraintGreaterThanOrEqualToAnchor:self.view.leadingAnchor
            constant:24],

        [self.cardView.trailingAnchor
            constraintLessThanOrEqualToAnchor:self.view.trailingAnchor
            constant:-24],

        [self.cardView.widthAnchor
            constraintLessThanOrEqualToConstant:app.cardMaxWidth],

        [self.titleLabel.topAnchor
            constraintEqualToAnchor:self.cardView.topAnchor
            constant:36],

        [self.titleLabel.leadingAnchor
            constraintEqualToAnchor:self.cardView.leadingAnchor
            constant:24],

        [self.titleLabel.trailingAnchor
            constraintEqualToAnchor:self.cardView.trailingAnchor
            constant:-24],

        [self.subtitleLabel.topAnchor
            constraintEqualToAnchor:self.titleLabel.bottomAnchor
            constant:12],

        [self.subtitleLabel.leadingAnchor
            constraintEqualToAnchor:self.cardView.leadingAnchor
            constant:24],

        [self.subtitleLabel.trailingAnchor
            constraintEqualToAnchor:self.cardView.trailingAnchor
            constant:-24],

        [self.telegramButton.topAnchor
            constraintEqualToAnchor:self.subtitleLabel.bottomAnchor
            constant:28],

        [self.telegramButton.leadingAnchor
            constraintEqualToAnchor:self.cardView.leadingAnchor
            constant:24],

        [self.telegramButton.trailingAnchor
            constraintEqualToAnchor:self.cardView.trailingAnchor
            constant:-24],

        [self.telegramButton.heightAnchor
            constraintEqualToConstant:app.buttonHeight],

        [self.githubButton.topAnchor
            constraintEqualToAnchor:self.telegramButton.bottomAnchor
            constant:12],

        [self.githubButton.leadingAnchor
            constraintEqualToAnchor:self.cardView.leadingAnchor
            constant:24],

        [self.githubButton.trailingAnchor
            constraintEqualToAnchor:self.cardView.trailingAnchor
            constant:-24],

        [self.githubButton.heightAnchor
            constraintEqualToConstant:app.buttonHeight],

        [self.continueButton.topAnchor
            constraintEqualToAnchor:self.githubButton.bottomAnchor
            constant:20],

        [self.continueButton.leadingAnchor
            constraintEqualToAnchor:self.cardView.leadingAnchor
            constant:24],

        [self.continueButton.trailingAnchor
            constraintEqualToAnchor:self.cardView.trailingAnchor
            constant:-24],

        [self.continueButton.heightAnchor
            constraintEqualToConstant:app.buttonHeight],

        [self.dontShowButton.topAnchor
            constraintEqualToAnchor:self.continueButton.bottomAnchor
            constant:16],

        [self.dontShowButton.centerXAnchor
            constraintEqualToAnchor:self.cardView.centerXAnchor],

        [self.dontShowButton.bottomAnchor
            constraintEqualToAnchor:self.cardView.bottomAnchor
            constant:-28]
    ]];
}

#pragma mark - Actions

- (void)telegramTapped {
    [URLOpener
        openURLString:
            [WelcomeConfig sharedConfig].linksConfig.telegram];
}

- (void)githubTapped {
    [URLOpener
        openURLString:
            [WelcomeConfig sharedConfig].linksConfig.github];
}

- (void)continueTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dontShowTapped {
    [UserDefaultsWelcome setHasSeenWelcome:YES];

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
