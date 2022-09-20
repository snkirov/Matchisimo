//
//  CardGameViewController.m
//  ObjectiveCTesting
//
//  Created by Svilen Kirov on 16/08/2022.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "HistoryViewController.h"

@interface CardGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cards;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *moveDescribingText;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSAttributedString *history;
@end

@implementation CardGameViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self startGame];
  [self updateUI];
  self.navigationItem.title = [self navigationTitle];
}

- (NSString *)navigationTitle {
  return @"Let's Play";
}

- (IBAction)flipCard:(UIButton *)sender {
  [self chooseCardForButton:sender];
  [self updateUI];
}

- (void)chooseCardForButton:(UIButton *)button {
  unsigned long chosenButtonIndex = [self.cards indexOfObject: button];
  [self.game chooseCardAtIndex: chosenButtonIndex];
}

- (IBAction)resetGame:(id)sender {
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
  _history = [[NSAttributedString alloc] initWithString:@""];
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
    Card *card = [self getCardForButton:cardButton];
    if (!card.isMatched) {
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
  Card *card = [self getCardForButton:cardButton];
  [self updateButton:cardButton withCard:card];
}

- (Card *)getCardForButton:(UIButton *)cardButton {
  unsigned long cardButtonIndex = [self.cards indexOfObject:cardButton];
  return [self.game cardAtIndex:cardButtonIndex];
}

- (void)updateButton:(UIButton *)cardButton withCard:(Card *)card {
  [self updateTitleOfButton:cardButton forCard:card];
  [cardButton setBackgroundImage: [self backgroundImageForCard: card] forState:UIControlStateNormal];
  cardButton.enabled = !card.isMatched;
}

- (void)updateTitleOfButton:(UIButton *)cardButton forCard:(Card *)card {
  NSLog(@"The updateTitleOfButton method of the CardGameViewController should be implemented in each subclass.");
}

- (UIImage *)backgroundImageForCard: (Card *)card {
  NSString * cardName = card.isChosen ? @"cardfront" : @"cardback";
  return [UIImage imageNamed: cardName];
}

@end
