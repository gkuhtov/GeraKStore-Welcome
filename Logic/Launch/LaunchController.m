#import "LaunchController.h"
#import "../FirstLaunch/FirstLaunchManager.h"
#import "../WelcomeScreen/WelcomeViewController.h"

@implementation LaunchController

+ (instancetype)sharedController {
    static LaunchController *controller;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        controller = [[LaunchController alloc] init];
    });

    return controller;
}

- (void)showWelcomeIfNeededFromViewController:(UIViewController *)viewController {
    if (viewController == nil) {
        return;
    }

    if (![[FirstLaunchManager sharedManager] shouldShowWelcome]) {
        return;
    }

    WelcomeViewController *welcome =
        [[WelcomeViewController alloc] init];

    welcome.modalPresentationStyle =
        UIModalPresentationFullScreen;

    [viewController presentViewController:welcome
                                 animated:YES
                               completion:nil];
}

@end
