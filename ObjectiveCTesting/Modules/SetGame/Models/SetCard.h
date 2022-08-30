// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#include "Card.h"

NS_ASSUME_NONNULL_BEGIN

@class UIColor;

@interface SetCard : Card

- (instancetype) initWithShape:(NSString *)shape withColor:(UIColor *)color
                    withStroke:(UIColor *)shading;

@property (strong, nonatomic)NSString *shape;
@property (strong, nonatomic)UIColor *color;
@property (strong, nonatomic)UIColor *stroke;

+ (NSArray<NSString *> *)validShapes;
+ (NSArray<UIColor *> *)validColors;
+ (NSArray<UIColor *> *)validStrokes;

@end

NS_ASSUME_NONNULL_END
