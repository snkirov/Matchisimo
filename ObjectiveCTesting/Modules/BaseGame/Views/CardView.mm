// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "CardView.h"

NS_ASSUME_NONNULL_BEGIN

@implementation CardView

static const CGFloat cornerFontStandardHeight = 180.0;
static const CGFloat cornerRadiusNotScaled = 12;

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / cornerFontStandardHeight; }
- (CGFloat)cornerRadius { return cornerRadiusNotScaled * [self cornerScaleFactor]; }

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
              format:@"drawCardInterior is an abstract method, which should be overriden by all children."];
}

- (void)setup {
  self.backgroundColor = nil;
  self.opaque = NO;
  self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self setup];
}

@end

NS_ASSUME_NONNULL_END
