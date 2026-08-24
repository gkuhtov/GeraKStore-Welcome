#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppearanceConfig : NSObject
@property (nonatomic, assign) CGFloat glassBlurRadius;
@property (nonatomic, assign) CGFloat glassOpacity;
@property (nonatomic, assign) CGFloat glassCornerRadius;
@property (nonatomic, assign) CGFloat logoSize;
@property (nonatomic, assign) CGFloat cardMaxWidth;
@property (nonatomic, assign) CGFloat buttonHeight;
@property (nonatomic, strong) NSArray<NSString *> *primaryGradient;
@property (nonatomic, strong) NSArray<NSString *> *backgroundGradient;
@property (nonatomic, assign) BOOL showMountains;
@property (nonatomic, assign) BOOL showStars;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
