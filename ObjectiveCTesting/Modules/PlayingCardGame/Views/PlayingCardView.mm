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

CGFloat defaultFaceCardScaleFactor = 0.90;
CGFloat cornerFontStandardHeight = 180.0;
CGFloat cornerRadiusNotScaled = 12;

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / cornerFontStandardHeight; }
- (CGFloat)cornerRadius { return cornerRadiusNotScaled * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }

- (void)setupWithPlayingCard:(PlayingCard *)card {
  _suit = card.suit;
  _rank = card.rank;
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
                                     self.bounds.size.width * (1.0 - defaultFaceCardScaleFactor),
                                     self.bounds.size.width * (1.0 - defaultFaceCardScaleFactor));
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

static double pipHorizontalOffsetPercentage = 0.165;
static double pipVerticalOffsetPercentageSmall = 0.090;
static double pipVerticalOffsetPercentageMedium = 0.175;
static double pipVerticalOffsetPercentageLarge = 0.270;

/// Method that draws the pips for a given card.
/// Horrible if statements, I would never write it that way. However I am also not willing to rewrite it, so am leaving as it is. It works!
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
  if ((self.rank == 4) || (self.rank == 5) || (self.rank == 6)
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

static double pipFontScaleFactor = 0.012;
static double pipOriginConstant = 2.0; // Pretty much a magic number, no idea how the guys chose it.

- (void)drawPipsWithHorizontalOffset:(CGFloat)horizontalOffset
                      verticalOffset:(CGFloat)verticalOffset
                  upsideDown:(Boolean)upsideDown {
  if (upsideDown) {
    [self pushContextAndRotateUpsideDown];
  }
  CGPoint centre = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
  UIFont *pipFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  pipFont = [pipFont fontWithSize:
             [pipFont pointSize] * self.bounds.size.width * pipFontScaleFactor];
  NSAttributedString *attributedSuit = [[NSAttributedString alloc]
                                        initWithString:self.suit
                                        attributes:@{ NSFontAttributeName : pipFont }];
  CGSize pipSize = [attributedSuit size];
  CGPoint pipOrigin = CGPointMake(centre.x - pipSize.width /
                                  pipOriginConstant - horizontalOffset * self.bounds.size.width,
                                  centre.y - pipSize.height /
                                  pipOriginConstant - verticalOffset * self.bounds.size.height);
  [attributedSuit drawAtPoint:pipOrigin];

  if (horizontalOffset) {
      pipOrigin.x += horizontalOffset * pipOriginConstant * self.bounds.size.width;
      [attributedSuit drawAtPoint:pipOrigin];
  }

  if (upsideDown) {
    [self popContext];
  }
}

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

- (NSArray<NSString *> *)rankStrings {
  return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

- (NSString *)rankAsString {

  if (self.rank <= [PlayingCardUtil maxRank]) {
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
