#import "WelcomeConfig.h"
#import "EmbeddedResourceLoader.h"

@implementation WelcomeConfig

+ (instancetype)sharedConfig {
    static WelcomeConfig *config = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        config = [[WelcomeConfig alloc] init];
    });

    return config;
}

- (instancetype)init {
    self = [super init];

    if (self) {
        _appConfig =
            [[AppConfig alloc]
                initWithDictionary:[self loadJSON:@"config"]];

        _textConfig =
            [[TextConfig alloc]
                initWithDictionary:[self loadJSON:@"texts"]];

        _linksConfig =
            [[LinksConfig alloc]
                initWithDictionary:[self loadJSON:@"links"]];

        _appearanceConfig =
            [[AppearanceConfig alloc]
                initWithDictionary:[self loadJSON:@"appearance"]];
    }

    return self;
}

- (NSDictionary *)loadJSON:(NSString *)name {

    /*
     * 1. Сначала ищем внешний Config внутри IPA.
     */
    NSString *path =
        [[NSBundle mainBundle]
            pathForResource:name
            ofType:@"json"
            inDirectory:@"Config"];

    if (!path) {
        path =
            [[NSBundle bundleForClass:[self class]]
                pathForResource:name
                ofType:@"json"
                inDirectory:@"Config"];
    }

    if (path) {
        NSData *data =
            [NSData dataWithContentsOfFile:path];

        if (data) {
            NSError *error = nil;

            NSDictionary *json =
                [NSJSONSerialization
                    JSONObjectWithData:data
                    options:0
                    error:&error];

            if ([json isKindOfClass:[NSDictionary class]]) {
                return json;
            }
        }
    }

    /*
     * 2. Если внешнего файла нет,
     *    используем встроенный ресурс dylib.
     */
    NSData *embedded =
        [EmbeddedResourceLoader
            dataForResource:name
            extension:@"json"];

    if (!embedded) {
        return @{};
    }

    NSError *error = nil;

    NSDictionary *json =
        [NSJSONSerialization
            JSONObjectWithData:embedded
            options:0
            error:&error];

    if ([json isKindOfClass:[NSDictionary class]]) {
        return json;
    }

    return @{};
}

@end
