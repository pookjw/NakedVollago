#import <UIKit/UIKit.h>
#import <libhooker/libhooker.h>

static id vlDrawerViewController = nil;

static id (*original_VLSitesContainerView_initWithFrame)(id self, SEL selector, CGRect frame);
static id custom_VLSitesContainerView_initWithFrame(id self, SEL selector, CGRect frame) {
    self = original_VLSitesContainerView_initWithFrame(self, selector, frame);
    if (self) {
        [(UIView *)self setAlpha:0.6f];
    }
    return self;
}

static id (*original_VLDrawerViewController_init)(id self, SEL selector);
static id custom_VLDrawerViewController_init(id self, SEL selector) {
    self = original_VLDrawerViewController_init(self, selector);
    vlDrawerViewController = self;
    return self;
}

static void (*original_UIView_setBackgroundColor)(UIView *self, SEL selector, UIColor *backgroundColor);
static void custom_UIView_setBackgroundColor(UIView *self, SEL selector, UIColor *backgroundColor) {
    if ([self isEqual:((UIViewController *)vlDrawerViewController).view]) {
        original_UIView_setBackgroundColor(self, selector, UIColor.clearColor);
    } else {
        original_UIView_setBackgroundColor(self, selector, backgroundColor);
    }
}

__attribute__((constructor)) static void init() {
    LBHookMessage(NSClassFromString(@"VLSitesContainerView"), @selector(initWithFrame:), &custom_VLSitesContainerView_initWithFrame, &original_VLSitesContainerView_initWithFrame);
    LBHookMessage(NSClassFromString(@"VLDrawerViewController"), @selector(init), &custom_VLDrawerViewController_init, &original_VLDrawerViewController_init);
    LBHookMessage([UIView class], @selector(setBackgroundColor:), &custom_UIView_setBackgroundColor, &original_UIView_setBackgroundColor);
}
