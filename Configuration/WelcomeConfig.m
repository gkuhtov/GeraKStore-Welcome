#import "WelcomeConfig.h"

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
        _appConfig = [[AppConfig alloc] initWithDictionary:[self loadJSON:@"config"]];
        _textConfig = [[TextConfig alloc] initWithDictionary:[self loadJSON:@"texts"]];
        _linksConfig = [[LinksConfig alloc] initWithDictionary:[self loadJSON:@"links"]];
        _appearanceConfig = [[AppearanceConfig alloc] initWithDictionary:[self loadJSON:@"appearance"]];
    }
    return self;
}

- (NSDictionary *)loadJSON:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json" inDirectory:@"Config"];
    if (!path) {
        // Fallback for development / different bundle structure
        path = [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:@"json"];
    }
    
    if (!path) return @{};
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (!data) return @{};
    
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    return json ?: @{};
}

@end
