#import "WelcomeManager.h"
#import "WelcomeViewController.h"
#import "WelcomeConfig.h"
#import "UserDefaults+Welcome.h"

@implementation WelcomeManager

+ (instancetype)sharedManager {
    static WelcomeManager *manager = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        manager = [[WelcomeManager alloc] init];
    });

    return manager;
}

- (void)startWelcomeIfNeeded {

    WelcomeConfig *config = [WelcomeConfig sharedConfig];

    if (!config.appConfig.enabled) {
        return;
    }

    if (config.appConfig.forceShowForDebug) {
        [self presentWelcomeWithRetry:0];
        return;
    }

    if (config.appConfig.showOnFirstLaunchOnly &&
        [UserDefaultsWelcome hasSeenWelcome]) {
        return;
    }

    [self presentWelcomeWithRetry:0];
}

- (void)presentWelcomeWithRetry:(NSInteger)attempt {

    if (attempt > 10) {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{

        UIWindow *window = [self keyWindow];

        if (!window ||
            !window.rootViewController ||
            !window.bounds.size.width ||
            !window.bounds.size.height) {

            dispatch_after(
                dispatch_time(DISPATCH_TIME_NOW,
                              (int64_t)(0.25 * NSEC_PER_SEC)),
                dispatch_get_main_queue(), ^{

                    [self presentWelcomeWithRetry:attempt + 1];
                }
            );

            return;
        }

        UIViewController *root = window.rootViewController;

        while (root.presentedViewController) {
            root = root.presentedViewController;
        }

        if ([root isKindOfClass:[WelcomeViewController class]]) {
            return;
        }

        if ([root.presentationController.presentedViewController
             isKindOfClass:[WelcomeViewController class]]) {
            return;
        }

        WelcomeViewController *vc =
            [[WelcomeViewController alloc] init];

        vc.modalPresentationStyle =
            UIModalPresentationFullScreen;

        vc.modalTransitionStyle =
            UIModalTransitionStyleCrossDissolve;

        [root presentViewController:vc
                           animated:YES
                         completion:nil];
    });
}

- (UIWindow *)keyWindow {

    UIApplication *application =
        [UIApplication sharedApplication];

    /*
     Современные iOS с UIScene.
    */
    if (@available(iOS 13.0, *)) {

        for (UIScene *scene in application.connectedScenes) {

            if (scene.activationState !=
                UISceneActivationStateForegroundActive) {
                continue;
            }

            if (![scene isKindOfClass:[UIWindowScene class]]) {
                continue;
            }

            UIWindowScene *windowScene =
                (UIWindowScene *)scene;

            for (UIWindow *window in windowScene.windows) {

                if (window.isKeyWindow &&
                    !window.hidden &&
                    window.rootViewController) {

                    return window;
                }
            }

            for (UIWindow *window in windowScene.windows) {

                if (!window.hidden &&
                    window.rootViewController) {

                    return window;
                }
            }
        }
    }

    /*
     Fallback для старых приложений.
    */
    for (UIWindow *window in application.windows) {

        if (window.isKeyWindow &&
            !window.hidden &&
            window.rootViewController) {

            return window;
        }
    }

    for (UIWindow *window in application.windows) {

        if (!window.hidden &&
            window.rootViewController) {

            return window;
        }
    }

    return nil;
}

@end
