//
//  YYAnimatedImageView+OLELayer.m
//  OLA-iOS
//
//  Created by niuge on 2020/9/25.
//  Copyright © 2020 olecx. All rights reserved.
//

#import "YYAnimatedImageView+OLELayer.h"
#import <objc/message.h>

@implementation YYAnimatedImageView (OLELayer)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method displayLayerMethod = class_getInstanceMethod(self, @selector(displayLayer:));
        Method displayLayerNewMethod = class_getInstanceMethod(self, @selector(displayLayerNew:));
        
        if (class_addMethod(YYAnimatedImageView.self, @selector(displayLayer:), method_getImplementation(displayLayerNewMethod), method_getTypeEncoding(displayLayerNewMethod))) {
            class_replaceMethod(YYAnimatedImageView.self, @selector(displayLayerNew:), method_getImplementation(displayLayerMethod), method_getTypeEncoding(displayLayerMethod));
        } else {
            method_exchangeImplementations(displayLayerMethod, displayLayerNewMethod);
        }
    });
}

- (void)displayLayerNew:(CALayer *)layer {
    
    Ivar imgIvar = class_getInstanceVariable([self class], "_curFrame");
    UIImage *img = object_getIvar(self, imgIvar);
    if (img) {
        layer.contentsScale = img.scale;
        layer.contents = (__bridge id)img.CGImage;
    } else {
        if (@available(iOS 14.0, *)) {
            [super displayLayer:layer];
        }
    }
}

@end
