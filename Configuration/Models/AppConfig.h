#import <Foundation/Foundation.h>

@interface AppConfig : NSObject
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) BOOL showOnFirstLaunchOnly;
@property (nonatomic, assign) BOOL allowSkip;
@property (nonatomic, assign) BOOL animationEnabled;
@property (nonatomic, assign) BOOL forceShowForDebug;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
