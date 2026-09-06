#import "WelcomeManager.h"
#import "WelcomeViewController.h"
#import "WelcomeConfig.h"
#import "UserDefaults+Welcome.h"

@interface WelcomeManager ()

@property (nonatomic, assign) BOOL welcomeShownThisSession;
@property (nonatomic, assign) BOOL presentationInProgress;

@end

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

    /*
     * Не запускаем Welcome повторно в рамках
     * одного жизненного цикла приложения.
     *
     * Это особенно важно для UIApplicationDidBecomeActiveNotification,
     * которое приходит каждый раз после возврата из фона.
     */
    if (self.welcomeShownThisSession ||
        self.presentationInProgress) {

        return;
    }

    WelcomeConfig *config =
        [WelcomeConfig sharedConfig];

    if (!config.appConfig.enabled) {
        return;
    }

    /*
     * Режим принудительного показа для отладки
     * тоже не должен срабатывать бесконечно
     * при каждом возврате из фона.
     */
    if (config.appConfig.forceShowForDebug) {

        self.welcomeShownThisSession = YES;

        [self presentWelcomeWithRetry:0];

        return;
    }

    /*
     * Если пользователь уже выбрал
     * "Больше не показывать", Welcome больше не нужен.
     */
    if (config.appConfig.showOnFirstLaunchOnly &&
        [UserDefaultsWelcome hasSeenWelcome]) {

        return;
    }

    self.welcomeShownThisSession = YES;

    [self presentWelcomeWithRetry:0];
}

- (void)presentWelcomeWithRetry:(NSInteger)attempt {

    if (attempt > 10) {

        self.presentationInProgress = NO;

        /*
         * Если показать Welcome не получилось,
         * разрешаем повторную попытку.
         */
        self.welcomeShownThisSession = NO;

        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{

        UIWindow *window = [self keyWindow];

        if (!window ||
            !window.rootViewController ||
            !window.bounds.size.width ||
            !window.bounds.size.height) {

            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    (int64_t)(0.25 * NSEC_PER_SEC)
                ),
                dispatch_get_main_queue(), ^{

                    [self presentWelcomeWithRetry:attempt + 1];
                }
            );

            return;
        }

        UIViewController *root =
            window.rootViewController;

        while (root.presentedViewController) {
            root = root.presentedViewController;
        }

        if ([root isKindOfClass:[WelcomeViewController class]]) {

            self.presentationInProgress = NO;

            return;
        }

        if ([root.presentationController.presentedViewController
             isKindOfClass:[WelcomeViewController class]]) {

            self.presentationInProgress = NO;

            return;
        }

        WelcomeViewController *vc =
            [[WelcomeViewController alloc] init];

        vc.modalPresentationStyle =
            UIModalPresentationFullScreen;

        vc.modalTransitionStyle =
            UIModalTransitionStyleCrossDissolve;

        self.presentationInProgress = YES;

        [root presentViewController:vc
                           animated:YES
                         completion:^{

            self.presentationInProgress = NO;
        }];
    });
}

- (UIWindow *)keyWindow {

    UIApplication *application =
        [UIApplication sharedApplication];

    /*
     * Современные iOS с UIScene.
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
     * Fallback для старых приложений.
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
