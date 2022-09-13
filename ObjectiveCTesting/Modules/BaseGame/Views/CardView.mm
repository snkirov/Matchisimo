// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "CardView.h"

NS_ASSUME_NONNULL_BEGIN

@implementation CardView

static const CGFloat cornerFontStandardHeight = 180.0;
static const CGFloat cornerRadiusNotScaled = 12;

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / cornerFontStandardHeight; }
- (CGFloat)cornerRadius { return cornerRadiusNotScaled * [self cornerScaleFactor]; }

- (void)setSelected:(BOOL)selected {
  _selected = selected;
  [self setNeedsDisplay];
}

- (void)selectCard {
  [UIView transitionWithView:self
                            duration:0.5
                             options:self.animationOptionForTap
                          animations:^{
    self.selected = !self.selected;
  } completion:^(BOOL completed){
    self.didTapView();
  }];
}

- (void)drawCardOutline {
  auto roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                         cornerRadius:self.cornerRadius];
  [roundedRect addClip];

  [[UIColor whiteColor] setFill];
  UIRectFill(self.bounds);

  [[UIColor blackColor] setStroke];
  [roundedRect stroke];
}

- (void)drawRect:(CGRect)rect {
  [self drawCardOutline];
  [self drawCardInterior];
}

- (void)drawCardInterior {
  [NSException raise:@"Draw Card Interior should be overwritten."
              format:@"drawCardInterior is an abstract method, which should be overwritten by all children."];
}

- (instancetype)init {
  if (self = [super init]) {
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
    self.selected = FALSE;
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
    self.selected = FALSE;
  }
  return self;
}

// MARK: - Abstract

- (UIViewAnimationOptions)animationOptionForTap {
  [NSException raise:@"Draw Card Interior should be overwritten."
              format:@"DrawCardInterior is an abstract method, which should be overwritten by all children."];
  return 0;
}

@end

NS_ASSUME_NONNULL_END
