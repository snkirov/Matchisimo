// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "BaseGameViewController.h"
#import "Grid.h"
#import "DeckFactory.h"
#import "CardMatchingGame.h"
#import "CardView.h"
#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseGameViewController()
@property (nonatomic, strong)UIView *cardCanvas;
@property (nonatomic, strong)UILabel *scoreLabel;
@property (nonatomic)NSMutableArray<CardView *> *cards;
@end

@implementation BaseGameViewController

static const CGFloat cellAspectRatio = 0.5625;
static const NSUInteger defaultCardCount = 30;
static const CGFloat edgeOffset = 20;

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupCardMatchingGame];
  [self initialGridSetup];
  [self setupPlayingSection];
  [self setupBottomBar];
  [self.cardCanvas layoutIfNeeded];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  /// Responsible for reloading the screen on screen rotation.
  /// Also fixes a bug with the grid not using the updated frame of the card canvas, once the tabbar gets added.
  [self reloadScreenAnimated:true];
}

// MARK: - Setup Methods

- (void)setupCardMatchingGame {
  [NSException raise:@"SetupCardMatchingGame should be overwritten."
              format:@"SetupCardMatchingGame is an abstract method, which should be overriden by all children."];
}

- (void)initialGridSetup {
  _cardGrid = [[Grid alloc] init];
  _cardGrid.cellAspectRatio = cellAspectRatio;
  _cardGrid.minCellWidth = 30;
  _cardGrid.minCellHeight = 30 * 16 / 9;
}

- (void)evaluateDefaultGrid {
  // The size is evaluated here, since the cardCanvas needs to be initialised to use it's frame.
  _cardGrid.size = _cardCanvas.frame.size;
  _cardGrid.minimumNumberOfCells = defaultCardCount;
}

- (void)setupPlayingSection {
  [self setupCardCanvas];
  [self evaluateDefaultGrid];
  [self setupCards];
  [self.view layoutIfNeeded];
}

- (void)setupCardCanvas {
  _cardCanvas = [[UIView alloc] init];
  [self.view addSubview:_cardCanvas];
  _cardCanvas.backgroundColor = UIColor.systemGray6Color;
  [self setupCardCanvasConstraints];
  [_cardCanvas layoutIfNeeded];
}

- (void)setupCards {
  _cards = [[NSMutableArray alloc] init];
  LogDebug(@"%@", _cardGrid);
  for (int i = 0; i < _cardGrid.rowCount; i++) {
    for (int j = 0; j < _cardGrid.columnCount; j++) {
      CardView *cardView = [self setupCardViewAtRow:i atColumn:j];
      [self addTapGestureRecognizerToCardView:cardView];
      [cardView setDidTapView:^{
        auto index = [_cardGrid getIndexForRow:i andColumn:j];
        [self didTapCardAtIndex: index];
      }];
      [_cards addObject:cardView];
      [_cardCanvas addSubview:cardView];
      if ([_cards count] == defaultCardCount) {
        return;
      }
    }
  }
  [self.cardCanvas layoutIfNeeded];
}

- (void)addTapGestureRecognizerToCardView:(CardView *)cardView {
  auto tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:cardView action:@selector(selectCard)];
  [cardView addGestureRecognizer:tapGestureRecognizer];
}

- (CardView *)setupCardViewAtRow:(NSUInteger)row atColumn:(NSUInteger)column {
  [NSException raise:@"SetupCardMatchingGame should be overwritten."
              format:@"SetupCardMatchingGame is an abstract method, which should be overriden by all children."];
  return nil;
}

- (void)setupBottomBar {
  [self setupScoreText];
  [self setupButtons];
}

- (void)setupScoreText {
  auto textView = [[UILabel alloc] init];
  textView.text = [self getCurrentScoreString];
  [self.view addSubview:textView];
  [self setupScoreTextConstraints:textView];
  [textView layoutIfNeeded];
  _scoreLabel = textView;
}

- (NSString *)getCurrentScoreString {
  auto scoreString =
    [[NSString alloc] initWithFormat:@"Score: %ld", (long)[_cardMatchingGame score]];
  return scoreString;
}

- (void)setupButtons {
  [self setupDrawButton];
  [self setupRedealButton];
}

- (void)setupDrawButton {
  auto drawButton = [[UIButton alloc] init];
  [drawButton setTitle:@"Draw" forState:UIControlStateNormal];
  [drawButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
  [drawButton addTarget:self action:@selector(didTapDraw) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:drawButton];
  [self setupDrawButtonConstraints:drawButton];
  [drawButton layoutIfNeeded];
}

- (void)didTapDraw {
  [self drawThreeMoreCards];
}

- (void)setupRedealButton {
  auto redealButton = [[UIButton alloc] init];
  [redealButton setTitle:@"Redeal" forState:UIControlStateNormal];
  [redealButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
  [redealButton addTarget:self action:@selector(didTapRedeal) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:redealButton];
  [self setupRedealButtonConstraints:redealButton];
  [redealButton layoutIfNeeded];
}

- (void)didTapRedeal {
  [self redealGame];
}

- (void)didTapCardAtIndex:(NSUInteger)index {
  [self.cardMatchingGame chooseCardAtIndex:index];
  [self updateUI];
  [self.view layoutIfNeeded];
}

- (void)updateUI {
  NSArray *newCards = [_cards copy];
  for (CardView *cardView in newCards) {
    [self updateCardView:cardView];
  }
  [self updateScore];
}

- (void)updateScore {
  _scoreLabel.text = [self getCurrentScoreString];
}

- (Card *)getCardForView:(CardView *)cardView {
  return nil;
}

- (void)updateCardView:(CardView *)cardView {
  auto dummyCard = [self getCardForView:cardView];
  auto card = [_cardMatchingGame getCardPointerForCard:dummyCard];
  if (card.isMatched) {
    [cardView removeFromSuperview];
    [_cards removeObject:cardView];
    [_cardMatchingGame removeCard:card];
    return;
  }
  if (card.isChosen) {
    [cardView setSelected:true];
  } else {
    [cardView setSelected:false];
  }
}

// MARK: - Reloading

- (void)drawThreeMoreCards {
  for (int i = 0; i < 3; i++) {
    auto cardView = [self setupCardViewAtIndex:_cards.count]; // cards count increases with each iteration
    cardView.frame = CGRectMake(0, self.cardCanvas.frame.size.height, 0, 0);
    [self addTapGestureRecognizerToCardView:cardView];
    [_cards addObject:cardView];
    [_cardCanvas addSubview:cardView];
  }
  [self reloadScreenAnimated:TRUE];
}

- (CardView *)setupCardViewAtIndex:(NSUInteger)index {
  [NSException raise:@"SetupCardViewAtIndex should be overwritten."
              format:@"SetupCardViewAtIndex is an abstract method, which should be overriden by all children."];
  return nil;
}

- (void)reloadScreenAnimated:(Boolean)isAnimated {
  [self reevaluateGrid];
  [self reloadCardsAnimated:isAnimated];
}

- (void)reevaluateGrid {
  // TODO: When adding three new cards this line is called even though it is not needed.
  _cardGrid.size = _cardCanvas.frame.size;
  _cardGrid.minimumNumberOfCells = _cards.count;
  LogDebug(@"%@", _cardGrid);
}

- (void)reloadCardsAnimated:(Boolean)isAnimated {
  for (int i = 0; i < _cards.count; i++) {
    auto row = i / _cardGrid.columnCount;
    auto column = i % _cardGrid.columnCount;
    [self.cards[i] setDidTapView:^{
      auto index = [_cardGrid getIndexForRow:row andColumn:column];
      [self didTapCardAtIndex: index];
    }];
    if (isAnimated) {
    [UIView animateWithDuration:1.0 animations:^{
      self.cards[i].frame = [self.cardGrid frameOfCellAtRow:row inColumn:column];
    }];
    } else {
      self.cards[i].frame = [self.cardGrid frameOfCellAtRow:row inColumn:column];
    }
  }
  [_cardCanvas layoutSubviews];
}

- (void)redealGame {
  [self.cardCanvas removeFromSuperview];
  [self setupCardMatchingGame];
  [self updateScore];
  [self setupPlayingSection];
}

// MARK: - Constraint methods
- (void)setupCardCanvasConstraints {
  _cardCanvas.translatesAutoresizingMaskIntoConstraints = NO;

  UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
  auto bottomOffset = self.view.frame.size.height / 8;
  auto leadingConstraint = [_cardCanvas.leadingAnchor
                            constraintEqualToAnchor:guide.leadingAnchor
                            constant: edgeOffset];
  auto trailingConstraint = [_cardCanvas.trailingAnchor
                             constraintEqualToAnchor:guide.trailingAnchor
                             constant: -edgeOffset];
  auto topConstraint = [_cardCanvas.topAnchor
                        constraintEqualToAnchor:guide.topAnchor
                        constant: edgeOffset];
  auto bottomConstraint = [_cardCanvas.bottomAnchor
                           constraintEqualToAnchor:guide.bottomAnchor
                           constant: -bottomOffset];

  leadingConstraint.active = true;
  trailingConstraint.active = true;
  topConstraint.active = true;
  bottomConstraint.active = true;
}

- (void)setupRedealButtonConstraints:(UIButton *)redealButton {
  redealButton.translatesAutoresizingMaskIntoConstraints = NO;

  UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
  auto bottomConstraint = [redealButton.bottomAnchor
                           constraintEqualToAnchor:guide.bottomAnchor
                           constant: -edgeOffset];
  auto trailingConstraint = [redealButton.trailingAnchor
                             constraintEqualToAnchor:guide.trailingAnchor
                             constant: -edgeOffset];

  bottomConstraint.active = true;
  trailingConstraint.active = true;
}

- (void)setupDrawButtonConstraints:(UIButton *)drawButton {
  drawButton.translatesAutoresizingMaskIntoConstraints = NO;

  UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
  auto bottomConstraint = [drawButton.bottomAnchor
                           constraintEqualToAnchor:guide.bottomAnchor
                           constant: -edgeOffset];
  auto trailingConstraint = [drawButton.leadingAnchor
                             constraintEqualToAnchor:guide.leadingAnchor
                             constant: edgeOffset];

  bottomConstraint.active = true;
  trailingConstraint.active = true;
}

- (void)setupScoreTextConstraints:(UILabel *)textView {
  textView.translatesAutoresizingMaskIntoConstraints = NO;

  UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
  auto bottomConstraint = [textView.bottomAnchor
                           constraintEqualToAnchor:guide.bottomAnchor
                           constant:-edgeOffset];
  auto centerConstraint = [textView.centerXAnchor constraintEqualToAnchor:guide.centerXAnchor];

  bottomConstraint.active = true;
  centerConstraint.active = true;
}

@end

NS_ASSUME_NONNULL_END
