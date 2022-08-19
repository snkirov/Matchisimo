// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#include <Foundation/Foundation.h>
#include "Card.h"
#include <UIKit/UIColor.h>

NS_ASSUME_NONNULL_BEGIN

@interface SetCard : Card

- (instancetype) initWithShape:(NSString *)shape withColor:(UIColor *)color
                    withStroke:(UIColor *)shading;

@property (readonly, nonatomic) NSMutableAttributedString *attributedContents;

+ (NSArray<NSString *> *)validShapes;
+ (NSArray<UIColor *> *)validColors;
+ (NSArray<UIColor *> *)validStrokes;

@end

NS_ASSUME_NONNULL_END