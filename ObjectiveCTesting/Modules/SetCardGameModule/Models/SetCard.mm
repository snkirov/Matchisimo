// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "SetCard.h"
#import <UIKit/NSAttributedString.h>

NS_ASSUME_NONNULL_BEGIN

@interface SetCard()
@property (strong, nonatomic)NSString *shape;
@property (strong, nonatomic)UIColor *color;
@property (strong, nonatomic)UIColor *stroke;
@property (readwrite, nonatomic)NSMutableAttributedString *attributedContents;
@end

@implementation SetCard

@synthesize attributedContents = _attributedContents;

- (instancetype)initWithShape:(NSString *)shape withColor:(UIColor *)color
                   withStroke:(UIColor *)stroke {

  if (self = [super init]) {

    // If any of the checks evaluates to false, we will enter the if statement and return nil
    if (![[SetCard validShapes] containsObject:shape] ||
        ![[SetCard validColors] containsObject:color] ||
        ![[SetCard validStrokes] containsObject:stroke]) {
      self = nil;
      return self;
    }
    _shape = shape;
    _color = color;
    _stroke = stroke;

    NSRange range;
    range.length = _shape.length;
    range.location = 0;
    _attributedContents = [[NSMutableAttributedString alloc] initWithString:_shape];
    [_attributedContents addAttributes:@{NSForegroundColorAttributeName : _color,
                            NSStrokeColorAttributeName : _stroke,
                            NSStrokeWidthAttributeName : @-7 } range: range];
  }
  return self;
}

- (NSAttributedString *)attributedContents {
  return _attributedContents;
}

- (int)match:(NSArray *)otherCards {
  int score = 0;
  NSMutableArray<NSString *> *shapes = [[SetCard validShapes] mutableCopy];
  NSMutableArray<UIColor *>  *colors = [[SetCard validColors] mutableCopy];
  NSMutableArray<UIColor *>  *strokes = [[SetCard validStrokes] mutableCopy];
  NSMutableArray<SetCard *> *cards = [otherCards mutableCopy];
  [cards addObject:self];

  for (SetCard *card in cards) {
    if ([shapes containsObject:card.shape]) {
      [shapes removeObject:card.shape];
    }
    if ([colors containsObject:card.color]) {
      [colors removeObject:card.color];
    }
    if ([strokes containsObject:card.stroke]) {
      [strokes removeObject:card.stroke];
    }
  }

  if ((shapes.count == 2 || shapes.count == 0) &&
      (colors.count == 2 || colors.count == 0) &&
      (strokes.count == 2 || strokes.count == 0)) {
    score = 4;
  }

  return score;
}

- (NSString *)contents {
  return _shape;
}

+ (NSArray<NSString *> *)validShapes {
  return @[@"▲", @"●", @"■"];
}

+ (NSArray<UIColor *>  *)validColors {
  return @[[UIColor redColor], [UIColor blueColor], [UIColor greenColor]];
}
+ (NSArray<UIColor *> *)validStrokes {
  return @[[UIColor blackColor], [UIColor orangeColor], [UIColor clearColor]];
}

@end

NS_ASSUME_NONNULL_END
