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
        [self presentWelcome];
        return;
    }
    
    if (config.appConfig.showOnFirstLaunchOnly && [UserDefaultsWelcome hasSeenWelcome]) {
        return;
    }
    
    [self presentWelcome];
}

- (void)presentWelcome {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [self keyWindow];
        if (!window) return;
        
        WelcomeViewController *vc = [[WelcomeViewController alloc] init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        UIViewController *root = window.rootViewController;
        while (root.presentedViewController) {
            root = root.presentedViewController;
        }
        
        [root presentViewController:vc animated:YES completion:nil];
    });
}

- (UIWindow *)keyWindow {
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.isKeyWindow) return window;
    }
    return [UIApplication sharedApplication].windows.firstObject;
}

@end
