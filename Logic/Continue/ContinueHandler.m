#import "ContinueHandler.h"
#import "../FirstLaunch/FirstLaunchManager.h"

@implementation ContinueHandler

+ (void)continueFromViewController:(UIViewController *)viewController {
    if (viewController == nil) {
        return;
    }

    [viewController dismissViewControllerAnimated:YES
                                         completion:nil];
}

+ (void)disableWelcomeAndContinueFromViewController:(UIViewController *)viewController {
    [[FirstLaunchManager sharedManager] disableWelcome];

    [self continueFromViewController:viewController];
}

@end
