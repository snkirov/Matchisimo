// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#include "Card.h"
#include "SetCardUtil.h"

NS_ASSUME_NONNULL_BEGIN

@class UIColor;

@interface SetCard : Card

@property (nonatomic)CARD_Shape shape;
@property (nonatomic)CARD_Color color;
@property (nonatomic)CARD_Fill fill;
@property (nonatomic)CARD_NumberOfObjects numberOfObjects;

@end

NS_ASSUME_NONNULL_END
