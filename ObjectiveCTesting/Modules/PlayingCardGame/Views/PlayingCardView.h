// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "CardView.h"

NS_ASSUME_NONNULL_BEGIN

@class PlayingCard;

/// A `CardView` which represents a `PlayingCard` model.
@interface PlayingCardView : CardView

/// The rank of the underlying card.
@property (nonatomic, readonly) NSUInteger rank;
/// The suit of the underlying card.
@property (nonatomic, readonly) NSString *suit;

/// Sets up the view with the provided `PlayingCard`.
- (void)setupWithPlayingCard:(PlayingCard *)card;

@end

NS_ASSUME_NONNULL_END
