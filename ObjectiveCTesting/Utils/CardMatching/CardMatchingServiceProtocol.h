// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

NS_ASSUME_NONNULL_BEGIN

@class Card;

@protocol CardMatchingServiceProtocol <NSObject>

- (int)matchCard:(Card *)card withOtherCards:(NSArray *)cards;

@end

NS_ASSUME_NONNULL_END
