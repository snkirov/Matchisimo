// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "CardMatchingGame.h"
#import "SetCardUtil.h"

NS_ASSUME_NONNULL_BEGIN

@class SetCard;

/// Handles `SetCard` specific game logic.
@interface SetCardMatchingGame : CardMatchingGame

/// Retrieves the `SetCard` model from the `cards` array for the given shape, color, fill and number of shapes.
- (SetCard *)getCardForShape:(CARD_Shape)shape
                    andColor:(CARD_Color)color
                     andFill:(CARD_Fill)fill
           andNumberOfShapes:(CARD_NumberOfShapes)numberOfShapes;

@end

NS_ASSUME_NONNULL_END
