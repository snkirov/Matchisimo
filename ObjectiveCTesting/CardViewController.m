//
//  CardViewController.m
//  ObjectiveCTesting
//
//  Created by Svilen Kirov on 16/08/2022.
//

#import "CardViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"

@interface CardViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cards;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *moveDescribingText;
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation CardViewController
- (void)viewDidLoad {
	[super viewDidLoad];
  [self startGame];
	// Do any additional setup after loading the view.
}

static const int MATCH_COUNT = 2;

- (void)startGame {
  Deck *playingDeck = [[PlayingCardDeck alloc] init];
  _game = [[CardMatchingGame alloc] initWithCardCount: _cards.count usingDeck: playingDeck withMatchCount: MATCH_COUNT];
}

- (IBAction)flipCard:(UIButton *)sender {

  unsigned long chosenButtonIndex = [self.cards indexOfObject: sender];
  
//  NSLog(@"Choose at index: %ld", chosenButtonIndex);

  [self.game chooseCardAtIndex: chosenButtonIndex];
  [self updateUI];
}

- (IBAction)resetGame:(id)sender {
  [self startGame];
  [self updateUI];
}

- (void)updateUI {
  for (UIButton *cardButton in self.cards) {
    unsigned long cardButtonIndex = [self.cards indexOfObject:cardButton];
    Card *card = [self.game cardAtIndex:cardButtonIndex];
    [cardButton setTitle: [self titleForCard: card] forState: UIControlStateNormal];
    [cardButton setBackgroundImage: [self backgroundImageForCard: card] forState:UIControlStateNormal];
    cardButton.enabled = !card.isMatched;
  }
  _moveDescribingText.text = _game.lastMoveDescription;
  _score.text = [NSString stringWithFormat:@"Score: %ld", (long)_game.score];
}

- (NSString *)titleForCard: (Card *)card {
  return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard: (Card *)card {
  NSString * cardName = card.isChosen ? @"cardfront" : @"cardback";
  return [UIImage imageNamed: cardName];
}


@end
