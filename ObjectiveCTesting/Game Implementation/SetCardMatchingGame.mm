// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "SetCardMatchingGame.h"
#import "SetCardMatchingService.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetCardMatchingGame()
@property (nonatomic, readwrite) id <CardMatchingServiceProtocol> matchingService;
@end

@implementation SetCardMatchingGame

@synthesize matchingService = _matchingService;

- (instancetype) init {
  if (self = [super init]) {
    self.matchingService = [[SetCardMatchingService alloc] init];
  }
  return self;
}
@end

NS_ASSUME_NONNULL_END
