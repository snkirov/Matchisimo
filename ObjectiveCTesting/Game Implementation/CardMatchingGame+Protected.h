// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#ifndef ObjectiveCTesting____FILEBASENAMEASIDENTIFIER_______FILEEXTENSION___
#define ObjectiveCTesting____FILEBASENAMEASIDENTIFIER_______FILEEXTENSION___

#import "CardMatchingGame.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CardMatchingServiceProtocol;

@interface CardMatchingGame ()

/// The underlying array of cards currently in play.
@property (nonatomic, strong) NSMutableArray<Card *> *cardsInPlay;
/// The matching service which is responsible for evaluating a match.
@property (nonatomic, readonly) id <CardMatchingServiceProtocol> matchingService;

@end

NS_ASSUME_NONNULL_END

#endif
