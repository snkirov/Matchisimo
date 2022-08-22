//
//  CardGameViewController.m
//  ObjectiveCTesting
//
//  Created by Svilen Kirov on 16/08/2022.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "HistoryViewController.h"
#import "SetCardDeck.h"

@interface CardGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cards;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *moveDescribingText;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSMutableAttributedString *history;
@end

@implementation CardGameViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self startGame];
  [self updateUI];
  self.navigationItem.title = @"Match Two";
}

- (IBAction)flipCard:(UIButton *)sender {
  unsigned long chosenButtonIndex = [self.cards indexOfObject: sender];
  [self.game chooseCardAtIndex: chosenButtonIndex];
  [self updateUI];
}

- (IBAction)resetGame:(id)sender {
  //  NSLog(@"History: %@", _history);
  [self startGame];
  [self updateUI];
}
- (IBAction)showHistory:(id)sender {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  HistoryViewController *historyViewController =
  [storyboard instantiateViewControllerWithIdentifier:@"HistoryViewController"];
  [historyViewController setupWithAttributedHistory:_history];
  [self.navigationController pushViewController:historyViewController animated:true];
}

- (void)startGame {
  _history = [[NSMutableAttributedString alloc] initWithString:@""];
  _game = [[CardMatchingGame alloc] initWithCardCount:_cards.count
                                            usingDeck:[self createDeck]
                                       withMatchCount: [self cardsRequiredForMatch]];
}

- (Deck *)createDeck {
  return nil;
}

- (NSUInteger)cardsRequiredForMatch {
  return 2;
}

- (void)updateUI {
  BOOL hasWon = true;
  for (UIButton *cardButton in self.cards) {
    [self updateButton:cardButton];
    if (cardButton.enabled) {
      hasWon = false;
    }
  }

  _score.text = [NSString stringWithFormat:@"Score: %ld", (long)_game.score];

  if (hasWon) {
    _moveDescribingText.text = @"Congrats, you won! 🎉";
  } else {
    _moveDescribingText.attributedText = _game.lastMoveDescription;
  }
  // Check that the last move report is non null and not an empty string
  NSMutableAttributedString *emptyAttributedString =
  [[NSMutableAttributedString alloc] initWithString:@""];

  if (_game.lastMoveDescription &&
      ![_game.lastMoveDescription isEqualToAttributedString:emptyAttributedString]) {
    // We do it this way to append the old history to the back
    NSMutableAttributedString *newLineAttributedString =
    [[NSMutableAttributedString alloc] initWithString:@"\n"];
    [newLineAttributedString appendAttributedString:_game.lastMoveDescription];
    [newLineAttributedString appendAttributedString:_history];
    _history = newLineAttributedString;
  }
}

- (void)updateButton:(UIButton *)cardButton {
  unsigned long cardButtonIndex = [self.cards indexOfObject:cardButton];
  Card *card = [self.game cardAtIndex:cardButtonIndex];
  [self updateTitleOfButton:cardButton forCard:card];
  [cardButton setBackgroundImage: [self backgroundImageForCard: card] forState:UIControlStateNormal];
  cardButton.enabled = !card.isMatched;
}

- (void)updateTitleOfButton:(UIButton *)cardButton forCard:(Card *)card {
  [cardButton setTitle: [self titleForCard: card] forState: UIControlStateNormal];
}

- (NSString *)titleForCard:(Card *)card {
  return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard: (Card *)card {
  NSString * cardName = card.isChosen ? @"cardfront" : @"cardback";
  return [UIImage imageNamed: cardName];
}

@end
