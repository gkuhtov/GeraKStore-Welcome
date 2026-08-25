#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppearanceConfig : NSObject

@property (nonatomic, assign) CGFloat glassBlurRadius;
@property (nonatomic, assign) CGFloat glassOpacity;
@property (nonatomic, assign) CGFloat glassCornerRadius;
@property (nonatomic, assign) CGFloat glassBorderWidth;
@property (nonatomic, copy) NSString *glassBorderColor;

@property (nonatomic, assign) CGFloat logoSize;
@property (nonatomic, assign) CGFloat logoTopOffset;

/* Logo heartbeat */
@property (nonatomic, assign) BOOL logoPulseEnabled;
@property (nonatomic, assign) CGFloat logoPulseScale;
@property (nonatomic, assign) CGFloat logoPulseFirstDuration;
@property (nonatomic, assign) CGFloat logoPulseSecondDuration;
@property (nonatomic, assign) CGFloat logoPulsePause;
@property (nonatomic, assign) BOOL logoHapticEnabled;

@property (nonatomic, assign) CGFloat cardMaxWidth;
@property (nonatomic, assign) CGFloat buttonHeight;
@property (nonatomic, assign) CGFloat spacing;

@property (nonatomic, copy) NSString *titleColor;
@property (nonatomic, copy) NSString *subtitleColor;
@property (nonatomic, strong) NSArray<NSString *> *primaryGradient;
@property (nonatomic, strong) NSArray<NSString *> *backgroundGradient;
@property (nonatomic, assign) BOOL showMountains;
@property (nonatomic, assign) BOOL showStars;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
