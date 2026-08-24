#import "URLOpener.h"

@implementation URLOpener

+ (void)openURLString:(NSString *)urlString {
    if (urlString.length == 0) return;

    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) return;

    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
