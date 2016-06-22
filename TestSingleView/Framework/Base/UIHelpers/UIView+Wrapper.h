//
//  UIView+Wrapper.h
//
//  Created by luongnguyen on 7/22/14.
//  Copyright (c) 2014 appiphany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView(Wrapper)

- (void) iterateWithOnCheck:(BOOL(^)(id))onCheck andOnProcess:(void(^)(id))onProcess;

- (void) setEnableUI:(BOOL)isEnable;
- (void) setLoading:(BOOL)isLoading;

@end
