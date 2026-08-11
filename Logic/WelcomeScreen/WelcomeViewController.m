#import "WelcomeViewController.h"
#import "../Continue/ContinueHandler.h"

@interface WelcomeViewController ()

@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *continueButton;
@property (nonatomic, strong) UIButton *hideButton;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupBackground];
    [self setupCard];
    [self setupContent];
    [self setupButtons];
}

#pragma mark - Background

- (void)setupBackground {
    self.view.backgroundColor =
        [UIColor colorWithRed:8.0 / 255.0
                        green:8.0 / 255.0
                         blue:12.0 / 255.0
                        alpha:1.0];
}

#pragma mark - Card

- (void)setupCard {
    self.cardView = [[UIView alloc] init];
    self.cardView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cardView.backgroundColor =
        [UIColor colorWithWhite:1.0 alpha:0.08];

    self.cardView.layer.cornerRadius = 24.0;
    self.cardView.layer.masksToBounds = YES;

    [self.view addSubview:self.cardView];

    [NSLayoutConstraint activateConstraints:@[
        [self.cardView.centerXAnchor
            constraintEqualToAnchor:self.view.centerXAnchor],

        [self.cardView.centerYAnchor
            constraintEqualToAnchor:self.view.centerYAnchor],

        [self.cardView.leadingAnchor
            constraintGreaterThanOrEqualToAnchor:self.view.leadingAnchor
            constant:24.0],

        [self.cardView.trailingAnchor
            constraintLessThanOrEqualToAnchor:self.view.trailingAnchor
            constant:-24.0],

        [self.cardView.widthAnchor
            constraintLessThanOrEqualToConstant:420.0]
    ]];
}

#pragma mark - Content

- (void)setupContent {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.text = @"Добро пожаловать";
    self.titleLabel.textColor = UIColor.whiteColor;
    self.titleLabel.font =
        [UIFont systemFontOfSize:28.0
                          weight:UIFontWeightBold];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;

    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.messageLabel.text =
        @"Приложение подготовлено и распространяется через GeraKStore";
    self.messageLabel.textColor =
        [UIColor colorWithWhite:1.0 alpha:0.65];
    self.messageLabel.font =
        [UIFont systemFontOfSize:16.0
                          weight:UIFontWeightRegular];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.numberOfLines = 0;

    [self.cardView addSubview:self.titleLabel];
    [self.cardView addSubview:self.messageLabel];

    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.topAnchor
            constraintEqualToAnchor:self.cardView.topAnchor
            constant:40.0],

        [self.titleLabel.leadingAnchor
            constraintEqualToAnchor:self.cardView.leadingAnchor
            constant:28.0],

        [self.titleLabel.trailingAnchor
            constraintEqualToAnchor:self.cardView.trailingAnchor
            constant:-28.0],

        [self.messageLabel.topAnchor
            constraintEqualToAnchor:self.titleLabel.bottomAnchor
            constant:14.0],

        [self.messageLabel.leadingAnchor
            constraintEqualToAnchor:self.cardView.leadingAnchor
            constant:28.0],

        [self.messageLabel.trailingAnchor
            constraintEqualToAnchor:self.cardView.trailingAnchor
            constant:-28.0]
    ]];
}

#pragma mark - Buttons

- (void)setupButtons {
    self.continueButton =
        [UIButton buttonWithType:UIButtonTypeSystem];

    self.continueButton.translatesAutoresizingMaskIntoConstraints = NO;

    [self.continueButton setTitle:@"Продолжить"
                         forState:UIControlStateNormal];

    [self.continueButton setTitleColor:UIColor.whiteColor
                              forState:UIControlStateNormal];

    self.continueButton.titleLabel.font =
        [UIFont systemFontOfSize:17.0
                          weight:UIFontWeightSemibold];

    self.continueButton.backgroundColor =
        [UIColor colorWithRed:1.0
                        green:79.0 / 255.0
                         blue:163.0 / 255.0
                        alpha:1.0];

    self.continueButton.layer.cornerRadius = 16.0;

    [self.continueButton addTarget:self
                            action:@selector(continuePressed)
                  forControlEvents:UIControlEventTouchUpInside];

    self.hideButton =
        [UIButton buttonWithType:UIButtonTypeSystem];

    self.hideButton.translatesAutoresizingMaskIntoConstraints = NO;

    [self.hideButton setTitle:@"Больше не показывать"
                     forState:UIControlStateNormal];

    [self.hideButton setTitleColor:
        [UIColor colorWithWhite:1.0 alpha:0.55]
                          forState:UIControlStateNormal];

    self.hideButton.titleLabel.font =
        [UIFont systemFontOfSize:14.0
                          weight:UIFontWeightRegular];

    [self.hideButton addTarget:self
                        action:@selector(hidePressed)
              forControlEvents:UIControlEventTouchUpInside];

    [self.cardView addSubview:self.continueButton];
    [self.cardView addSubview:self.hideButton];

    [NSLayoutConstraint activateConstraints:@[
        [self.continueButton.topAnchor
            constraintEqualToAnchor:self.messageLabel.bottomAnchor
            constant:28.0],

        [self.continueButton.leadingAnchor
            constraintEqualToAnchor:self.cardView.leadingAnchor
            constant:28.0],

        [self.continueButton.trailingAnchor
            constraintEqualToAnchor:self.cardView.trailingAnchor
            constant:-28.0],

        [self.continueButton.heightAnchor
            constraintEqualToConstant:52.0],

        [self.hideButton.topAnchor
            constraintEqualToAnchor:self.continueButton.bottomAnchor
            constant:16.0],

        [self.hideButton.centerXAnchor
            constraintEqualToAnchor:self.cardView.centerXAnchor],

        [self.hideButton.bottomAnchor
            constraintEqualToAnchor:self.cardView.bottomAnchor
            constant:-28.0]
    ]];
}

#pragma mark - Actions

- (void)continuePressed {
    [ContinueHandler continueFromViewController:self];
}

- (void)hidePressed {
    [ContinueHandler disableWelcomeAndContinueFromViewController:self];
}

@end
