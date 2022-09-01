// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Deck;

@interface DeckFactory : NSObject

+ (Deck *)generateDeckWithPlayingCards;
+ (Deck *)generateDeckWithSetCards;

@end

NS_ASSUME_NONNULL_END
