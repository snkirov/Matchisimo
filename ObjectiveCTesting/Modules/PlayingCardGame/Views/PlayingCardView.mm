// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "PlayingCardView.h"
#import "PlayingCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PlayingCardView

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

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }


- (void)drawRect:(CGRect)rect {
  UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadius];
  [roundedRect addClip];

  [[UIColor whiteColor] setFill];
  UIRectFill(self.bounds);
  [[UIColor blackColor] setStroke];
  [roundedRect stroke];
  [self drawCorners];
}

- (NSArray<NSString *> *)rankStrings {
  return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

- (void)drawCorners {
  auto *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.alignment = NSTextAlignmentCenter;

  auto *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];

  NSString *rankAsString;
  if (self.rank <= [PlayingCard maxRank]) {
    rankAsString = [self rankStrings][self.rank];
  } else {
    rankAsString = [self rankStrings][0];
  }
  auto cornerString = [[NSString alloc] initWithFormat:@"%@\n%@", rankAsString, self.suit];
  auto cornerText = [[NSAttributedString alloc] initWithString: cornerString attributes:@{
    NSFontAttributeName : cornerFont, NSParagraphStyleAttributeName : paragraphStyle }];
  CGRect textBounds;
  textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
  textBounds.size = [cornerText size];
  [cornerText drawInRect:textBounds];
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
