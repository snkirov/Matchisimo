// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "UIKit/UIKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardView : UIView
@property (nonatomic)BOOL selected;
@property (nonatomic, copy) void (^didTapView)(void);

- (CGFloat)cornerScaleFactor;
- (CGFloat)cornerRadius;
- (void)drawCardInterior;
- (void)selectCard;
@end

NS_ASSUME_NONNULL_END
