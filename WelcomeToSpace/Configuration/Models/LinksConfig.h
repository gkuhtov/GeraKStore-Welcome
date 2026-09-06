#import <Foundation/Foundation.h>

@interface LinksConfig : NSObject
@property (nonatomic, copy) NSString *telegram;
@property (nonatomic, copy) NSString *github;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
