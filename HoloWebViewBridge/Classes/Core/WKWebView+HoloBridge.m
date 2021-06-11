//
//  WKWebView+HoloBridge.m
//  HoloWebViewBridge
//
//  Created by 与佳期 on 2021/1/26.
//

#import "WKWebView+HoloBridge.h"
#import <objc/runtime.h>

@implementation WKWebView (HoloBridge)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = NSSelectorFromString(@"dealloc");
        SEL swizzledSelector = @selector(_holoBridge_dealloc);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)_holoBridge_dealloc {
    [self.configuration.userContentController removeScriptMessageHandlerForName:@"bridge"];
    [self _holoBridge_dealloc];
}

@end
