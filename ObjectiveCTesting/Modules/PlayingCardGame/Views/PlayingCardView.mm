// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "PlayingCardView.h"
#import "PlayingCard.h"
#import "PlayingCardUtil.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayingCardView()
@property (nonatomic, readwrite) NSUInteger rank;
@property (nonatomic, readwrite) NSString *suit;
@end

@implementation PlayingCardView

- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }

- (void)setupWithPlayingCard:(PlayingCard *)card {
  _suit = card.suit;
  _rank = card.rank;
  [self setNeedsDisplay];
}

- (void)drawCardInterior {
  if (self.selected) {
    [self drawFaceUpCard];
    return;
  }
  [self drawFaceDownCard];
}

- (void)drawFaceUpCard {

  auto imageName = [NSString stringWithFormat:@"%@%@", [self rankAsString], self.suit];
  auto faceImage = [UIImage imageNamed:imageName];
  if (faceImage) {
    [self drawFaceUpCardWithImage:faceImage];
    [self drawCorners];
    return;
  }
  [self drawPips];
  [self drawCorners];
}

- (void)drawFaceUpCardWithImage:(UIImage *)faceImage {
  const CGFloat defaultFaceCardScaleFactor = 0.90;
  CGRect imageRect = CGRectInset(self.bounds,
                                 self.bounds.size.width * (1.0 - defaultFaceCardScaleFactor),
                                 self.bounds.size.width * (1.0 - defaultFaceCardScaleFactor));
  [faceImage drawInRect:imageRect];
}

- (void)drawFaceDownCard {
  auto backImage = [UIImage imageNamed:@"cardback"];
  [backImage drawInRect:self.bounds];
}

// MARK: - Draw Corners

- (void)drawCorners {
  auto cornerText = [self generateCornerText];
  // Draw in top left corner
  auto textBounds = [self createBoundsForAttributedString:cornerText];
  [cornerText drawInRect:textBounds];

  // Copy and translate to bottom right corner
  [self drawBottomRightCornerWithText:cornerText forBounds:textBounds];
}

- (void)drawBottomRightCornerWithText:(NSAttributedString *)cornerText forBounds:(CGRect)textBounds {
  [self pushContextAndRotateUpsideDown];
  [cornerText drawInRect:textBounds];
  [self popContext];
}

- (NSAttributedString *)generateCornerText {
  auto paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.alignment = NSTextAlignmentCenter;

  auto cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];

  auto rankAsString = [self rankAsString];
  auto cornerString = [[NSString alloc] initWithFormat:@"%@\n%@", rankAsString, self.suit];
  return [[NSAttributedString alloc] initWithString: cornerString attributes:@{
    NSFontAttributeName : cornerFont, NSParagraphStyleAttributeName : paragraphStyle }];
}

- (CGRect)createBoundsForAttributedString:(NSAttributedString *)attributedString {
  CGRect textBounds;
  textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
  textBounds.size = [attributedString size];
  return textBounds;
}

// MARK: - Pips magic

static double pipHorizontalOffsetPercentage = 0.145;
static double pipVerticalOffsetPercentageSmall = 0.090;
static double pipVerticalOffsetPercentageMedium = 0.175;
static double pipVerticalOffsetPercentageLarge = 0.270;

/// Method that draws the pips for a given card.
/// Difficult to understand, however I am not willing to rewrite it, so am leaving as it is. It works!
- (void)drawPips {
  if ((self.rank == 1) || (self.rank == 3) || (self.rank == 5) || (self.rank == 9)) {
    [self drawPipsWithHorizontalOffset:0
                        verticalOffset:0
                    mirroredVertically:FALSE];
  }
  if ((self.rank == 6) || (self.rank == 7) || (self.rank == 8)) {
    [self drawPipsWithHorizontalOffset:pipHorizontalOffsetPercentage
                        verticalOffset:0
                    mirroredVertically:FALSE];
  }
  if ((self.rank == 2) || (self.rank == 3) || (self.rank == 7)
      || (self.rank == 8) || (self.rank == 10)) {
    [self drawPipsWithHorizontalOffset:0
                        verticalOffset:pipVerticalOffsetPercentageMedium
                    mirroredVertically:(self.rank != 7)];
  }
  if ((self.rank == 4) || (self.rank == 5) || (self.rank == 6) || (self.rank == 7)
      || (self.rank == 8) || (self.rank == 9) || (self.rank == 10)) {
    [self drawPipsWithHorizontalOffset:pipHorizontalOffsetPercentage
                        verticalOffset:pipVerticalOffsetPercentageLarge
                    mirroredVertically:TRUE];
  }
  if ((self.rank == 9) || (self.rank == 10)) {
    [self drawPipsWithHorizontalOffset:pipHorizontalOffsetPercentage
                        verticalOffset:pipVerticalOffsetPercentageSmall
                    mirroredVertically:TRUE];
  }
}

static double pipFontScaleFactor = 0.009;
static double pipOriginConstant = 2.0; // Pretty much a magic number, no idea how the guys chose it.

- (void)drawPipsWithHorizontalOffset:(CGFloat)horizontalOffset
                      verticalOffset:(CGFloat)verticalOffset
                  mirroredVertically:(Boolean)mirroredVertically {

  [self drawPipsWithHorizontalOffset:horizontalOffset
                      verticalOffset:verticalOffset
                          upsideDown:FALSE];
  if (mirroredVertically) {
    [self drawPipsWithHorizontalOffset:horizontalOffset
                        verticalOffset:verticalOffset
                            upsideDown:TRUE];
  }
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)horizontalOffset
                      verticalOffset:(CGFloat)verticalOffset
                  upsideDown:(Boolean)upsideDown {
  if (!upsideDown) {
    [self drawPipsWithHorizontalOffset:horizontalOffset verticalOffset:verticalOffset];
    return;
  }

  [self pushContextAndRotateUpsideDown];
  [self drawPipsWithHorizontalOffset:horizontalOffset verticalOffset:verticalOffset];
  [self popContext];
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)horizontalOffset
                      verticalOffset:(CGFloat)verticalOffset {
  auto centre = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
  NSAttributedString *attributedSuit = [self generateAttributedSuit];
  CGSize pipSize = [attributedSuit size];
  auto pipOrigin = CGPointMake(centre.x - pipSize.width /
                               pipOriginConstant - horizontalOffset * self.bounds.size.width,
                               centre.y - pipSize.height /
                               pipOriginConstant - verticalOffset * self.bounds.size.height);
  [attributedSuit drawAtPoint:pipOrigin];

  if (horizontalOffset) {
    pipOrigin.x += horizontalOffset * pipOriginConstant * self.bounds.size.width;
    [attributedSuit drawAtPoint:pipOrigin];
  }
}

- (NSAttributedString *)generateAttributedSuit {
  auto pipFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  pipFont = [pipFont fontWithSize:
             [pipFont pointSize] * self.bounds.size.width * pipFontScaleFactor];
  auto attributedSuit = [[NSAttributedString alloc]
                         initWithString:self.suit
                         attributes:@{ NSFontAttributeName : pipFont }];
  return attributedSuit;
}

// MARK: - Utility methods

- (NSString *)rankAsString {
  return [PlayingCardUtil rankStrings][self.rank];
}

- (void)pushContextAndRotateUpsideDown {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
  CGContextRotateCTM(context, M_PI);
}

- (void)popContext {
  CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

@end

NS_ASSUME_NONNULL_END
