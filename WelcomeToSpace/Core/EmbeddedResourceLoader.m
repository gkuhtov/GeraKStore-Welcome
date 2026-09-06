#import "EmbeddedResourceLoader.h"
#import <UIKit/UIKit.h>
#import <mach-o/loader.h>
#import <mach-o/getsect.h>
#import <dlfcn.h>

@implementation EmbeddedResourceLoader

static void GeraKStoreWelcomeResourceAnchor(void) {
}

+ (NSData *)dataForResource:(NSString *)name
                   extension:(NSString *)extension {

    NSString *sectionName = nil;

    if ([name isEqualToString:@"config"] &&
        [extension isEqualToString:@"json"]) {

        sectionName = @"__welcome_config";

    } else if ([name isEqualToString:@"texts"] &&
               [extension isEqualToString:@"json"]) {

        sectionName = @"__welcome_texts";

    } else if ([name isEqualToString:@"links"] &&
               [extension isEqualToString:@"json"]) {

        sectionName = @"__welcome_links";

    } else if ([name isEqualToString:@"appearance"] &&
               [extension isEqualToString:@"json"]) {

        sectionName = @"__welcome_app";

    } else if ([name isEqualToString:@"GeraKStoreWelcome"] &&
               [extension isEqualToString:@"png"]) {

        sectionName = @"__welcome_logo";
    }

    if (!sectionName) {
        return nil;
    }

    Dl_info info;

    if (dladdr((const void *)&GeraKStoreWelcomeResourceAnchor, &info) == 0) {
        return nil;
    }

    if (!info.dli_fbase) {
        return nil;
    }

    const struct mach_header_64 *header =
        (const struct mach_header_64 *)info.dli_fbase;

    unsigned long size = 0;

    uint8_t *data = getsectiondata(
        header,
        "__DATA",
        [sectionName UTF8String],
        &size
    );

    if (!data || size == 0) {
        return nil;
    }

    return [NSData dataWithBytes:data length:size];
}

+ (UIImage *)imageForResource:(NSString *)name
                    extension:(NSString *)extension {

    NSData *data =
        [self dataForResource:name extension:extension];

    if (!data) {
        return nil;
    }

    return [UIImage imageWithData:data
                            scale:[UIScreen mainScreen].scale];
}

@end
