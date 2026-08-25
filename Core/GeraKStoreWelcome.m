#import "GeraKStoreWelcome.h"
#import "WelcomeManager.h"
#import <UIKit/UIKit.h>

@implementation GeraKStoreWelcome

__attribute__((constructor))
static void GeraKStoreWelcomeLoad(void) {

    dispatch_async(dispatch_get_main_queue(), ^{

        [[NSNotificationCenter defaultCenter]
            addObserverForName:UIApplicationDidBecomeActiveNotification
            object:nil
            queue:[NSOperationQueue mainQueue]
            usingBlock:^(NSNotification *notification) {

                [GeraKStoreWelcome start];
            }];

        /*
         Запасной запуск для приложений,
         которые уже стали активными к моменту загрузки dylib.
        */
        if (UIApplication.sharedApplication.applicationState ==
            UIApplicationStateActive) {

            dispatch_after(
                dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
                dispatch_get_main_queue(), ^{
                    [GeraKStoreWelcome start];
                }
            );
        }
    });
}

+ (void)start {
    [[WelcomeManager sharedManager] startWelcomeIfNeeded];
}

@end
