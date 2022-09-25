#import <Foundation/Foundation.h>
#import <libhooker/libhooker.h>
#import <SpringBoard/SBApplicationInfo.h>

static NSString * const vollagoBundleIdentifier = @"io.mywizz.Vollago";

static NSUInteger (*original_SBApplicationInfo_backgroundStyle)(SBApplicationInfo *self, SEL selector);
static NSUInteger custom_SBApplicationInfo_backgroundStyle(SBApplicationInfo *self, SEL selector) {
    if ([self.bundleIdentifier isEqualToString:vollagoBundleIdentifier]) {
        return 4; // like com.apple.mobilesafari
    } else {
        return original_SBApplicationInfo_backgroundStyle(self, selector);
    }
}

static BOOL (*original_SBApplicationInfo_canChangeBackgroundStyle)(SBApplicationInfo *self, SEL selector);
static BOOL custom_SBApplicationInfo_canChangeBackgroundStyle(SBApplicationInfo *self, SEL selector) {
    if ([self.bundleIdentifier isEqualToString:vollagoBundleIdentifier]) {
        return YES; // like com.apple.mobilesafari
    } else {
        return original_SBApplicationInfo_canChangeBackgroundStyle(self, selector);
    }
}

__attribute__((constructor)) static void init() {
    LBHookMessage(NSClassFromString(@"SBApplicationInfo"), @selector(backgroundStyle), &custom_SBApplicationInfo_backgroundStyle, &original_SBApplicationInfo_backgroundStyle);
    LBHookMessage(NSClassFromString(@"SBApplicationInfo"), @selector(canChangeBackgroundStyle), &custom_SBApplicationInfo_canChangeBackgroundStyle, &original_SBApplicationInfo_canChangeBackgroundStyle);
}
