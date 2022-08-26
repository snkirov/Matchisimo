// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CardMatchingProtocol <NSObject>

- (int)matchCard:(Card *)card withOtherCards:(NSArray *)cards;

@end

NS_ASSUME_NONNULL_END
