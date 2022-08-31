// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "SetCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SetCard

- (NSString *)contents {
  return [[NSString alloc] initWithFormat:@"Shape: %d NumberOfShapes: %d Fill: %d Color: %d",
          _shape, _numberOfShapes, _fill, _color];
}

@end

NS_ASSUME_NONNULL_END
