// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "SetCard.h"
#import "SetCardUtil.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SetCard

- (instancetype) initWithShape:(CARD_Shape)shape withColor:(CARD_Color)color withFill:(CARD_Fill)fill withNumberOfShapes:(CARD_NumberOfShapes)numberOfShapes {
  if (self = [super init]) {
    auto shapesCount = [[SetCardUtil shapesArray] count];
    auto colorsCount = [[SetCardUtil colorsArray] count];
    auto fillsCount = [[SetCardUtil fillsArray] count];
    auto numberOfShapesCount = [[SetCardUtil numberOfShapesArray] count];

    if (shape > shapesCount || shape < 1 ||
        color > colorsCount || color < 1 ||
        fill > fillsCount || fill < 1 ||
        numberOfShapes > numberOfShapesCount || numberOfShapes < 1) {
      LogDebug(@"Couldn't initialise SetCard, shape: %u, color: %u, fill: %u or numberOfShapes: %u is invalid,", shape, color, fill, numberOfShapes);
      return nil;
    }

    _shape = shape;
    _color = color;
    _fill = fill;
    _numberOfShapes = numberOfShapes;
  }
  return self;
}

- (NSString *)debugDescription {
  return [[NSString alloc] initWithFormat:@"Shape: %d NumberOfShapes: %d Fill: %d Color: %d",
          _shape, _numberOfShapes, _fill, _color];
}

@end

NS_ASSUME_NONNULL_END
