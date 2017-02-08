//
//  UIView+FixViewDebugging.m
//  TGWeibo
//
//  Created by Theodore Guo on 7/2/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

#ifdef DEBUG

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@implementation UIView (FixViewDebugging)

+ (void)load
{
    Method original = class_getInstanceMethod(self, @selector(viewForBaselineLayout));
    class_addMethod(self, @selector(viewForFirstBaselineLayout), method_getImplementation(original), method_getTypeEncoding(original));
    class_addMethod(self, @selector(viewForLastBaselineLayout), method_getImplementation(original), method_getTypeEncoding(original));
}

@end

#endif
