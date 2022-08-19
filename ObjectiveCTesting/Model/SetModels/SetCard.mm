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
      _attributedContents = [[[NSMutableAttributedString alloc] init] initWithString:_shape];
      NSRange range;
      range.length = _shape.length;
      range.location = 0;
      [_attributedContents addAttributes:@{ NSForegroundColorAttributeName : _color,
                                            NSStrokeColorAttributeName : _stroke,
                                            NSStrokeWidthAttributeName : @-5 } range: range];
    }
    return self;
  }

  + (NSArray<NSString *> *)validShapes {
    return @[@"▲", @"●", @"■"];
  }

  + (NSArray<UIColor *>  *)validColors {
    return @[[UIColor redColor], [UIColor blueColor], [UIColor greenColor], [UIColor purpleColor]];
  }
  + (NSArray<UIColor *> *)validStrokes {
    return @[[UIColor blackColor], [UIColor grayColor], [UIColor darkGrayColor]];
  }

  @end

  NS_ASSUME_NONNULL_END
