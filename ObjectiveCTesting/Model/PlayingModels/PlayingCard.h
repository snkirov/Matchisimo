// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import <Foundation/Foundation.h>
#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayingCard : Card
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+(NSArray *)validSuits;
+(NSUInteger)maxRank;
@end

NS_ASSUME_NONNULL_END
