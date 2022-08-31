// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "SetCardView.h"
#import "SetCardUtil.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SetCardView

- (void)setShape:(CARD_Shape)shape {
  _shape = shape;
  [self setNeedsDisplay];
}

- (void)setColor:(CARD_Color)color {
  _color = color;
  [self setNeedsDisplay];
}

- (void)setFill:(CARD_Fill)fill {
  _fill = fill;
  [self setNeedsDisplay];
}

- (void)setNumberOfShapes:(CARD_NumberOfShapes)numberOfShapes {
  _numberOfShapes = numberOfShapes;
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
  [self drawCardOutline];
  [self drawCardInterior];
}

- (void)drawCardInterior {
  CGRect dimensions;
  dimensions.origin = CGPointMake(self.bounds.size.width / 3, self.bounds.size.height / 3);
  auto widthAndHeight = MIN(self.bounds.size.width, self.bounds.size.height) / 3;
  auto rect = CGRectMake(self.bounds.size.width / 3, self.bounds.size.height / 3,
             widthAndHeight, widthAndHeight);
  
  auto diamond = [UIBezierPath bezierPathWithRect:rect];
  [diamond addClip];

  [[self getColor] setFill];
  UIRectFill(rect);

  [[UIColor blackColor] setStroke];
  [diamond stroke];
}

- (UIColor *)getColor {
  switch (_color) {
    case Green:
      return UIColor.greenColor;
    case Red:
      return UIColor.redColor;
    case Purple:
      return UIColor.purpleColor;
    case colorsCount:
      NSLog(@"[Warning] Color shouldn't be set to colorsCount in SetCardView.getColor");
      return UIColor.clearColor;
  }
}

- (void)drawShapeAtOffset:(CGFloat)offset {

}

- (void)drawOval {

}

- (void)drawDiamond {

}

- (void)drawSquiggle {

}

// TODO: Svilen Candidates for abstraction
#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }

- (void)setup {
  self.backgroundColor = nil;
  self.opaque = NO;
  self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self setup];
}

- (void)drawCardOutline {
  UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                         cornerRadius:self.cornerRadius];
  [roundedRect addClip];

  [[UIColor whiteColor] setFill];
  UIRectFill(self.bounds);

  [[UIColor blackColor] setStroke];
  [roundedRect stroke];
}

@end

NS_ASSUME_NONNULL_END
