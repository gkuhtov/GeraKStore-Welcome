#import <Foundation/Foundation.h>
#import "AppConfig.h"
#import "TextConfig.h"
#import "LinksConfig.h"
#import "AppearanceConfig.h"

@interface WelcomeConfig : NSObject

@property (nonatomic, strong, readonly) AppConfig *appConfig;
@property (nonatomic, strong, readonly) TextConfig *textConfig;
@property (nonatomic, strong, readonly) LinksConfig *linksConfig;
@property (nonatomic, strong, readonly) AppearanceConfig *appearanceConfig;

+ (instancetype)sharedConfig;

@end
