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
#import "History/HistoryViewController.h"

@interface CardViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cards;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *moveDescribingText;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSString *history;
@end

@implementation CardViewController

static const int MATCH_COUNT = 2;


- (void)viewDidLoad {
  [super viewDidLoad];
  [self startGame];
  self.navigationItem.title = @"Match Two";
}

- (IBAction)flipCard:(UIButton *)sender {
  unsigned long chosenButtonIndex = [self.cards indexOfObject: sender];
  [self.game chooseCardAtIndex: chosenButtonIndex];
  [self updateUI];
}

- (IBAction)resetGame:(id)sender {
  NSLog(@"History: %@", _history);
  [self startGame];
  [self updateUI];
}
- (IBAction)showHistory:(id)sender {
//  let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//  let nextViewController = storyBoard.instantiateViewController(withIdentifier: "nextView") as! NextViewController
//  self.present(nextViewController, animated:true, completion:nil)
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  HistoryViewController *historyViewController = [storyboard instantiateViewControllerWithIdentifier:@"HistoryViewController"];
  historyViewController.history = _history;
  [self.navigationController pushViewController:historyViewController animated:true];
}

- (void)startGame {
  Deck *playingDeck = [[PlayingCardDeck alloc] init];
  _history = @"";
  _game = [[CardMatchingGame alloc] initWithCardCount:_cards.count
                                            usingDeck:playingDeck withMatchCount: MATCH_COUNT];
}

- (void)updateUI {
  BOOL hasWon = true;
  for (UIButton *cardButton in self.cards) {
    unsigned long cardButtonIndex = [self.cards indexOfObject:cardButton];
    Card *card = [self.game cardAtIndex:cardButtonIndex];
    [cardButton setTitle: [self titleForCard: card] forState: UIControlStateNormal];
    [cardButton setBackgroundImage: [self backgroundImageForCard: card] forState:UIControlStateNormal];
    cardButton.enabled = !card.isMatched;
    if (cardButton.enabled) {
      hasWon = false;
    }
  }

  _score.text = [NSString stringWithFormat:@"Score: %ld", (long)_game.score];

  if (hasWon) {
  _moveDescribingText.text = @"Congrats, you won! 🎉";
  } else {
    if (_game.lastMoveDescription) {
      _moveDescribingText.text = _game.lastMoveDescription;
    }
  }
  if (![_moveDescribingText.text isEqualToString:@""]) {
    _history = [_moveDescribingText.text stringByAppendingString:[NSString stringWithFormat:@"\n%@", _history]];
  }
}

- (NSString *)titleForCard: (Card *)card {
  return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard: (Card *)card {
  NSString * cardName = card.isChosen ? @"cardfront" : @"cardback";
  return [UIImage imageNamed: cardName];
}

@end
