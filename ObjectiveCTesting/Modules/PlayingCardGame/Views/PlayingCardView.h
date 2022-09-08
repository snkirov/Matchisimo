// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PlayingCard;

@interface PlayingCardView : UIView

- (void)setupWithPlayingCard:(PlayingCard *)card;

@property (nonatomic, readonly) NSUInteger rank;
@property (nonatomic, readonly) NSString *suit;
@property (nonatomic) BOOL faceUp;

@end

NS_ASSUME_NONNULL_END
