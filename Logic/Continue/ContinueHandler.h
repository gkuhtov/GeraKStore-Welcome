#import <UIKit/UIKit.h>

@interface ContinueHandler : NSObject

+ (void)continueFromViewController:(UIViewController *)viewController;

+ (void)disableWelcomeAndContinueFromViewController:(UIViewController *)viewController;

@end
