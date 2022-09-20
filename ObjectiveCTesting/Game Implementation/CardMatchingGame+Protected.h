// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#ifndef ObjectiveCTesting____FILEBASENAMEASIDENTIFIER_______FILEEXTENSION___
#define ObjectiveCTesting____FILEBASENAMEASIDENTIFIER_______FILEEXTENSION___

#import "CardMatchingGame.h"

@interface CardMatchingGame ()

/// The underlying array of cards used for the game.
/// It contains not only the cards currently in play, but also the cards which can be added into play.
@property (nonatomic, strong)NSMutableArray<Card *> *cards;
/// The matching service which is responsible for evaluating a match.
@property (nonatomic, readonly)id <CardMatchingServiceProtocol> matchingService;

@end

#endif
