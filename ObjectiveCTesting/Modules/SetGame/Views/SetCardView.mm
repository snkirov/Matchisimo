// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "SetCardView.h"
#import "SetCardUtil.h"
#import "SetCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SetCardView

- (UIViewAnimationOptions)animationOptionForTap {
  return UIViewAnimationOptionTransitionCrossDissolve;
}

- (void)setupWithSetCard:(SetCard *)card {
  _shape = card.shape;
  _color = card.color;
  _fill = card.fill;
  _numberOfShapes = card.numberOfShapes;
  [self setNeedsDisplay];
}

- (void)drawCardInterior {
  self.alpha = self.selected ? 0.5 : 1.0;
  auto offsetForThreeShapes = self.bounds.size.height / 4;
  auto offsetForTwoShapes = offsetForThreeShapes / 2;
  auto offsetForOneShape = 0;

  switch (_numberOfShapes) {
    case One:
      [self drawShapeAtOffset:offsetForOneShape];
      return;
    case Two:
      [self drawShapeAtOffset:offsetForTwoShapes];
      [self drawShapeAtOffset:-offsetForTwoShapes];
      return;
    case Three:
      [self drawShapeAtOffset:offsetForOneShape];
      [self drawShapeAtOffset:offsetForThreeShapes];
      [self drawShapeAtOffset:-offsetForThreeShapes];
      return;
    case numberOfShapesCount:
      LogDebug(@"NumberOfShapes shouldn't be set to numberOfShapesCount in SetCardView.getColor");
      return;
  }
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
      LogDebug(@"Color shouldn't be set to colorsCount in SetCardView.getColor");
      return UIColor.clearColor;
  }
}

// MARK: - Shape Methods

- (void)drawShapeAtOffset:(CGFloat)offset {
  auto rect = [self generateRectAtOffset:offset];
  const auto context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  switch (_shape) {
    case Oval:
      [self drawOvalforRect:rect];
      break;
    case Diamond:
      [self drawDiamondforRect:rect];
      break;
    case Squiggle:
      [self drawSquiggleforRect:rect];
      break;
    case shapesCount:
      LogDebug(@"Shape shouldn't be set to shapesCount in SetCardView.drawShape");
      break;
  }
  CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

- (CGRect)generateRectAtOffset:(CGFloat)offset {
  auto boundsScaleDownFactor = 3;
  auto rectX = self.bounds.size.width / (boundsScaleDownFactor * 2);
  auto rectY = self.bounds.size.height / 2.5 + offset;
  auto widthAndHeight =
    MIN(self.bounds.size.width, self.bounds.size.height) / boundsScaleDownFactor;

  auto rect = CGRectMake(rectX, rectY, widthAndHeight * 2, widthAndHeight);
  return rect;
}

// MARK: - Oval & Diamond

- (void)drawOvalforRect:(CGRect)rect {
  auto path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:30];
  [self fillShapeForPath:path];
}

- (void)drawDiamondforRect:(CGRect)rect {
  auto path = [self generateDiamondPathForRect:rect];
  [self fillShapeForPath:path];
}

- (UIBezierPath *)generateDiamondPathForRect:(CGRect)rect {
  auto originX = rect.origin.x;
  auto originY = rect.origin.y;
  auto width = rect.size.width;
  auto height = rect.size.height;
  auto path = [[UIBezierPath alloc] init];

  [path moveToPoint:CGPointMake(originX, originY + height / 2)];
  [path addLineToPoint:CGPointMake(originX + width / 2, originY)];
  [path addLineToPoint:CGPointMake(originX + width, originY + height / 2)];
  [path addLineToPoint:CGPointMake(originX + width / 2, originY + height)];
  [path closePath];

  return path;
}

// MARK: - Squiggle

- (void)drawSquiggleforRect:(CGRect)rect {
  auto path = [self generateSquigglePathForRect:rect];
  [self fillShapeForPath:path];
}

- (UIBezierPath *)generateSquigglePathForRect:(CGRect)rect {
  const auto originX = rect.origin.x;
  const auto originY = rect.origin.y;
  const auto width = rect.size.width;
  const auto height = rect.size.height;
  auto path = [[UIBezierPath alloc] init];

  [path moveToPoint:CGPointMake(originX + rect.size.width*0.05, rect.origin.y + rect.size.height*0.40)];

  [path addCurveToPoint:CGPointMake(originX + width*0.35, originY + height*0.25)
          controlPoint1:CGPointMake(originX + width*0.09, originY + height*0.15)
          controlPoint2:CGPointMake(originX + width*0.18, originY + height*0.10)];

  [path addCurveToPoint:CGPointMake(originX + width*0.75, originY + height*0.30)
          controlPoint1:CGPointMake(originX + width*0.40, originY + height*0.30)
          controlPoint2:CGPointMake(originX + width*0.60, originY + height*0.45)];

  [path addCurveToPoint:CGPointMake(originX + width*0.97, originY + height*0.35)
          controlPoint1:CGPointMake(originX + width*0.87, originY + height*0.15)
          controlPoint2:CGPointMake(originX + width*0.98, originY + height*0.00)];

  [path addCurveToPoint:CGPointMake(originX + width*0.45, originY + height*0.85)
          controlPoint1:CGPointMake(originX + width*0.95, originY + height*1.10)
          controlPoint2:CGPointMake(originX + width*0.50, originY + height*0.95)];

  [path addCurveToPoint:CGPointMake(originX + width*0.25, originY + height*0.85)
          controlPoint1:CGPointMake(originX + width*0.40, originY + height*0.80)
          controlPoint2:CGPointMake(originX + width*0.35, originY + height*0.75)];

  [path addCurveToPoint:CGPointMake(originX + width*0.05, originY + height*0.40)
          controlPoint1:CGPointMake(originX + width*0.00, originY + height*1.10)
          controlPoint2:CGPointMake(originX + width*0.005, originY + height*0.60)];

  [path closePath];
  return path;
}

// MARK: - Fill

- (void)fillShapeForPath:(UIBezierPath *) path {

  [self strokeShapeFromPath:path];

  switch (_fill) {
    case Unfilled:
      // Every shape is unfilled(stroke) by default. No need to do additional filling here.
      return;
    case Striped:
      [self stripedFillForPath:path];
      return;
    case Solid:
      [self solidFillForPath:path];
      return;
    case fillsCount:
      LogDebug(@"Fill shouldn't be set to fillsCount in SetCardView.setFillMethod");
      return;
  }
}

- (void)strokeShapeFromPath:(UIBezierPath *)path {
  path.lineWidth = 2;
  [path addClip];
  [[self getColor] setStroke];
  [path stroke];
}

- (void)stripedFillForPath:(UIBezierPath *)path {

  auto stripedPath = [self drawStripedInternalForPath:path];
  [[self getColor] setStroke];
  [[self getColor] setFill];
  [path addClip];

  [stripedPath stroke];
}

- (UIBezierPath *)drawStripedInternalForPath:(UIBezierPath *)path {
  const auto bounds = [path bounds];
  auto stripedPath = [[UIBezierPath alloc] init];
  auto distanceBetweenStripes = 4;

  for (int i = 0; i < bounds.size.width; i += distanceBetweenStripes) {
    [stripedPath moveToPoint:CGPointMake(bounds.origin.x + i, bounds.origin.y)];
    [stripedPath addLineToPoint:CGPointMake(bounds.origin.x + i, bounds.origin.y + bounds.size.height)];
  }
  return stripedPath;
}

- (void)solidFillForPath:(UIBezierPath *)path {
  [[self getColor] setFill];
  [path fill];
}

@end

NS_ASSUME_NONNULL_END
