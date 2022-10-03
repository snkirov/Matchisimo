// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#include "CardProtocol.h"
#include "SetCardUtil.h"

NS_ASSUME_NONNULL_BEGIN

@class UIColor;

/// Defines a model of a card for the `SetCardGame`.
@interface SetCard : NSObject <CardProtocol>

/// The shape(s) on the card.
@property (nonatomic, readonly) CARD_Shape shape;
/// The color of the shape(s) on the card.
@property (nonatomic, readonly) CARD_Color color;
/// The fill of the shape(s) of the card.
@property (nonatomic, readonly) CARD_Fill fill;
/// The number of shapes on the card.
@property (nonatomic, readonly) CARD_NumberOfShapes numberOfShapes;

- (instancetype)initWithShape:(CARD_Shape)shape withColor:(CARD_Color)color
                     withFill:(CARD_Fill)fill withNumberOfShapes:(CARD_NumberOfShapes)numberOfShapes;

@end

NS_ASSUME_NONNULL_END
