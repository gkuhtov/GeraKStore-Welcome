#import <Foundation/Foundation.h>

@interface TextConfig : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *continueButton;
@property (nonatomic, copy) NSString *dontShowAgain;
@property (nonatomic, copy) NSString *telegramButton;
@property (nonatomic, copy) NSString *githubButton;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
