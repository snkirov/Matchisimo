// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "CardMatchingGame.h"
#import "SetCardUtil.h"

NS_ASSUME_NONNULL_BEGIN

@class SetCard;

@interface SetCardMatchingGame : CardMatchingGame

- (SetCard *)getCardForShape:(CARD_Shape)shape
                    andColor:(CARD_Color)color
                     andFill:(CARD_Fill)fill
           andNumberOfShapes:(CARD_NumberOfShapes)numberOfShapes;

@end

NS_ASSUME_NONNULL_END
