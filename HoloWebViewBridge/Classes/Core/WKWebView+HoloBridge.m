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
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self.class, @selector(holoBridge_dealloc)));
}

- (void)holoBridge_dealloc {
    [self.configuration.userContentController removeScriptMessageHandlerForName:@"bridge"];
    [self holoBridge_dealloc];
}

@end
