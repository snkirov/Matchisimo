// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "UIKit/UIKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardView : UIView
- (CGFloat)cornerScaleFactor;
- (CGFloat)cornerRadius;
- (void)drawCardInterior;
@end

NS_ASSUME_NONNULL_END
