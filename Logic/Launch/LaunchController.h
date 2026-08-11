#import <UIKit/UIKit.h>

@interface LaunchController : NSObject

+ (instancetype)sharedController;

- (void)showWelcomeIfNeededFromViewController:(UIViewController *)viewController;

@end
