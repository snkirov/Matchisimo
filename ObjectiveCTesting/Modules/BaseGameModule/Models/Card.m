//
//  Card.m
//  ObjectiveCTesting
//
//  Created by Svilen Kirov on 16/08/2022.
//

#import "Card.h"

@interface Card()

@end

@implementation Card

- (NSMutableAttributedString *)attributedContents {
  return [[NSMutableAttributedString alloc] initWithString: [self contents]];
}

- (int)match:(NSArray *)otherCards {
	int score = 0;
  for (Card *card in otherCards) {
    if([card.contents isEqualToString:self.contents]) {
      score += 1;
    }
  }
	return score;
}

@end
