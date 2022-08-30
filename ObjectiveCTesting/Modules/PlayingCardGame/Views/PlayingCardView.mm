// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "PlayingCardView.h"
#import "PlayingCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PlayingCardView

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90
#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }

- (void)setSuit:(NSString *)suit {
  _suit = suit;
  [self setNeedsDisplay];
}

- (void)setRank:(NSUInteger)rank {
  _rank = rank;
  [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp {
  _faceUp = faceUp;
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
  UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                         cornerRadius:self.cornerRadius];
  [roundedRect addClip];

  [[UIColor whiteColor] setFill];
  UIRectFill(self.bounds);

  [[UIColor blackColor] setStroke];
  [roundedRect stroke];

  if (self.faceUp) {
    UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",
                                              [self rankAsString], self.suit]];
    if (faceImage) {
      CGRect imageRect = CGRectInset(self.bounds,
                                     self.bounds.size.width * (1.0 - DEFAULT_FACE_CARD_SCALE_FACTOR),
                                     self.bounds.size.width * (1.0 - DEFAULT_FACE_CARD_SCALE_FACTOR));
      [faceImage drawInRect:imageRect];
    } else {
      [self drawPips];
    }

    [self drawCorners];
  } else {
    auto backImage = [UIImage imageNamed:@"cardback"];
    [backImage drawInRect:self.bounds];
  }
}

- (void)drawPips {

}

- (NSArray<NSString *> *)rankStrings {
  return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

- (NSString *)rankAsString {

  if (self.rank <= [PlayingCard maxRank]) {
    return [self rankStrings][self.rank];
  }

  return [self rankStrings][0];
}

- (void)drawCorners {
  auto cornerText = [self generateCornerText];
  // Draw in top left corner
  auto textBounds = [self createBoundsForAttributedString:cornerText];
  [cornerText drawInRect:textBounds];

  // Copy and translate to bottom right corner
  [self pushContextAndRotateUpsideDown];
  [cornerText drawInRect:textBounds];
  [self popContext];
}

- (CGRect)createBoundsForAttributedString:(NSAttributedString *)attributedString {
  CGRect textBounds;
  textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
  textBounds.size = [attributedString size];
  return textBounds;
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

- (NSAttributedString *)generateCornerText {
  auto *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.alignment = NSTextAlignmentCenter;

  auto *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];

  auto rankAsString = [self rankAsString];
  auto cornerString = [[NSString alloc] initWithFormat:@"%@\n%@", rankAsString, self.suit];
  return [[NSAttributedString alloc] initWithString: cornerString attributes:@{
    NSFontAttributeName : cornerFont, NSParagraphStyleAttributeName : paragraphStyle }];
}

- (void)setup {
  self.backgroundColor = nil;
  self.opaque = NO;
  self.contentMode = UIViewContentModeRedraw;
  self.suit = [PlayingCard validSuits][0];
  self.rank = [PlayingCard maxRank];
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self setup];
}

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {

  }
  return self;
}

@end

NS_ASSUME_NONNULL_END
