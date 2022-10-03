// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "CardView.h"
#import "SetCardUtil.h"
NS_ASSUME_NONNULL_BEGIN

@class SetCard;

/// A `CardView` which represents a `SetCard` model.
@interface SetCardView : CardView

/// The shape of the underlying card.
@property (nonatomic, readonly) CARD_Shape shape;
/// The color of the underlying card.
@property (nonatomic, readonly) CARD_Color color;
/// The fill of the underlying card.
@property (nonatomic, readonly) CARD_Fill fill;
/// The number of shapes of the underlying card.
@property (nonatomic, readonly) CARD_NumberOfShapes numberOfShapes;

/// Sets up the view with the provided `SetCard`.
-(void)setupWithSetCard:(SetCard *)card;

@end

NS_ASSUME_NONNULL_END
