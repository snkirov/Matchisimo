// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "PlayingCardMatchingGame.h"
#import "PlayingCardMatchingService.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayingCardMatchingGame()
@property (nonatomic, readwrite) id <CardMatchingServiceProtocol> matchingService;
@end

@implementation PlayingCardMatchingGame

@synthesize matchingService = _matchingService;

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
                   withMatchCount:(NSUInteger) matchCount {
  if (self = [super initWithCardCount:count usingDeck:deck withMatchCount:matchCount]) {
    self.matchingService = [[PlayingCardMatchingService alloc] init];
  }
  return self;
}

@end

NS_ASSUME_NONNULL_END
