#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface EmbeddedResourceLoader : NSObject

+ (NSData *)dataForResource:(NSString *)name
                   extension:(NSString *)extension;

+ (UIImage *)imageForResource:(NSString *)name
                    extension:(NSString *)extension;

@end
