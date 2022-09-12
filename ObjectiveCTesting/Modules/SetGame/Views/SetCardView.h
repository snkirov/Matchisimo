// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "SetCardUtil.h"
#import "CardView.h"
NS_ASSUME_NONNULL_BEGIN

@class SetCard;

@interface SetCardView : CardView

-(void)setupWithSetCard:(SetCard *)card;
// Is it better to expose all of the properties or just expose the underlying object?
@property (nonatomic, readonly)CARD_Shape shape;
@property (nonatomic, readonly)CARD_Color color;
@property (nonatomic, readonly)CARD_Fill fill;
@property (nonatomic, readonly)CARD_NumberOfShapes numberOfShapes;

@end

NS_ASSUME_NONNULL_END
