// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import <UIKit/UIKit.h>

@class Card, CardView, Grid, CardMatchingGame;
NS_ASSUME_NONNULL_BEGIN

@interface BaseGameViewController : UIViewController
@property (nonatomic, strong)CardMatchingGame *cardMatchingGame;
@property (nonatomic, strong)Grid *cardGrid;

// Protected

- (void)setupCardMatchingGame;
- (CardView *)generateCardView;
- (Card *)getCardForView:(CardView *)cardView;

@end

NS_ASSUME_NONNULL_END
