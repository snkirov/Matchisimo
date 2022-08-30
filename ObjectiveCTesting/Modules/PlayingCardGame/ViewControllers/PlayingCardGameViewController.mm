// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "PlayingCardGameViewController.h"
#import "PlayingCardView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayingCardGameViewController()
@property (weak, nonatomic) IBOutlet PlayingCardView *cardView;
@end

@implementation PlayingCardGameViewController

- (void) viewDidLoad {
  [super viewDidLoad];
  _cardView.suit = @"♥️";
  _cardView.rank = 12;
}

@end

NS_ASSUME_NONNULL_END
