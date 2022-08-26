// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "SetCard.h"
#import <UIKit/NSAttributedString.h>

NS_ASSUME_NONNULL_BEGIN

@implementation SetCard

// TODO: Svilen replace with setters
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
  }
  return self;
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
