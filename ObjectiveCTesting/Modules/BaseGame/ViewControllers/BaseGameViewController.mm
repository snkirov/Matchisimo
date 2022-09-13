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
@property (nonatomic, strong)UIButton *drawButton;
@property (nonatomic, strong)UILabel *scoreLabel;
@property (nonatomic)NSMutableArray<CardView *> *cardViews;
@end

@implementation BaseGameViewController

static const CGFloat cellAspectRatio = 0.5625;
static const NSUInteger defaultCardCount = 12;
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
  [self reloadScreenAnimated:FALSE];
}

// MARK: - Setup Methods

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
  _cardViews = [[NSMutableArray alloc] init];
  for (int i = 0; i < _cardGrid.rowCount; i++) {
    for (int j = 0; j < _cardGrid.columnCount; j++) {
      CardView *cardView = [self generateCardView];
      auto frame = [_cardGrid frameOfCellAtRow:i inColumn:j];
      [self drawCardViewWithRedrawAnimation:cardView withFrame:frame];
      [self addDidTapActionToCardView:cardView];
      [_cardViews addObject:cardView];
      [_cardCanvas addSubview:cardView];
      if ([_cardViews count] == defaultCardCount) {
        return;
      }
    }
  }
  [self.cardCanvas layoutIfNeeded];
}

- (void)drawCardViewWithRedrawAnimation:(CardView *)cardView withFrame:(CGRect)frame {
  cardView.frame = CGRectMake(self.view.center.x, self.view.center.y / 2, 0, 0);
  [UIView animateWithDuration:1.0 animations:^{
    cardView.frame = frame;
  }];
}

- (void)addDidTapActionToCardView:(CardView *)cardView {
  [self addTapGestureRecognizerToCardView:cardView];
  
  __weak BaseGameViewController *weakSelf = self;
  __weak CardView *weakCardView = cardView;
  [cardView setDidTapView:^{
    auto strongSelf = weakSelf;
    auto strongCardView = weakCardView;
    [strongSelf didTapCardView: strongCardView];
  }];
}

- (void)addTapGestureRecognizerToCardView:(CardView *)cardView {
  auto tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                               initWithTarget:cardView
                               action:@selector(selectCard)];
  [cardView addGestureRecognizer:tapGestureRecognizer];
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
  _drawButton = [[UIButton alloc] init];
  [_drawButton setTitle:@"Draw" forState:UIControlStateNormal];
  [_drawButton setTitle:@"Deck Empty" forState:UIControlStateDisabled];
  [_drawButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
  [_drawButton addTarget:self action:@selector(didTapDraw:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_drawButton];
  [self setupDrawButtonConstraints:_drawButton];
  [_drawButton layoutIfNeeded];
}

- (void)didTapDraw:(UIButton *)button {
  [self drawMoreCards];
}

- (void)disableDrawButtonIfNeeded {
  if (!_drawButton.isEnabled) {
    return;
  }
  [_drawButton setEnabled:FALSE];
  [_drawButton layoutIfNeeded];
}

- (void)resetDrawButtonIfNeeded {
  if (_drawButton.isEnabled) {
    return;
  }
  [_drawButton setEnabled:TRUE];
  [_drawButton layoutIfNeeded];
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

- (void)didTapCardView:(CardView *)cardView {
  auto card = [self getCardForView:cardView];
  card = [_cardMatchingGame getCardPointerForCard:card];
  [_cardMatchingGame chooseCard:card];
  [self updateUI];
  [self.view layoutIfNeeded];
}

- (void)updateUI {
  // This is needed, since we can't modify an array which is being iterated over.
  NSArray *newCards = [_cardViews copy];
  for (CardView *cardView in newCards) {
    [self updateCardView:cardView];
  }
  [self reloadScreenAnimated:TRUE];
  [self updateScore];
}

- (void)updateScore {
  _scoreLabel.text = [self getCurrentScoreString];
}

- (void)updateCardView:(CardView *)cardView {
  auto dummyCard = [self getCardForView:cardView];
  // TODO: Do the same thing, but in the child VC, don't pass a card as a parameter, rather the different properties as standalone parameters
  auto card = [_cardMatchingGame getCardPointerForCard:dummyCard];
  if (card.isMatched) {
    [cardView removeFromSuperview];
    [_cardViews removeObject:cardView];
    [_cardMatchingGame removeCard:card];
    return;
  }
  if (card.isChosen) {
    [cardView setSelected:TRUE];
  } else {
    [cardView setSelected:FALSE];
  }
}

// MARK: - Reloading

- (void)drawMoreCards {
  auto cardsPerDraw = 3;
  for (int i = 0; i < cardsPerDraw; i++) {
    auto cardView = [self generateCardView];
    // Make the card appear from the bottom left corner
    cardView.frame = CGRectMake(0, self.cardCanvas.frame.size.height, 0, 0);
    [self addDidTapActionToCardView:cardView];
    [_cardViews addObject:cardView];
    [_cardCanvas addSubview:cardView];
    if (![_cardMatchingGame canDrawMore]) {
      [self disableDrawButtonIfNeeded];
      break;
    }
  }
  [self reloadScreenAnimated:TRUE];
}

- (void)reloadScreenAnimated:(Boolean)isAnimated {
  [self reevaluateGrid];
  [self reloadCardsAnimated:isAnimated];
}

- (void)reevaluateGrid {
  // TODO: When adding three new cards this line is called even though it is not needed.
  _cardGrid.size = _cardCanvas.frame.size;
  _cardGrid.minimumNumberOfCells = _cardViews.count;
}

- (void)reloadCardsAnimated:(Boolean)isAnimated {
  if (isAnimated) {
    [self reloadCardsAnimated];
  } else {
    [self reloadCardsNotAnimated];
  }
}

- (void)reloadCardsAnimated {
  for (int i = 0; i < _cardViews.count; i++) {
    auto row = [_cardGrid getRowForIndex:i];
    auto column = [_cardGrid getColumnForIndex:i];
    [UIView animateWithDuration:1.0 animations:^{
      self.cardViews[i].frame = [self.cardGrid frameOfCellAtRow:row inColumn:column];
    }];
  }
  [_cardCanvas layoutSubviews];
}

- (void)reloadCardsNotAnimated {
  for (int i = 0; i < _cardViews.count; i++) {
    auto row = [_cardGrid getRowForIndex:i];
    auto column = [_cardGrid getColumnForIndex:i];
    self.cardViews[i].frame = [self.cardGrid frameOfCellAtRow:row inColumn:column];
  }
  [_cardCanvas layoutSubviews];
}

- (void)redealGame {
  [self.cardCanvas removeFromSuperview];
  [self setupCardMatchingGame];
  [self updateScore];
  [self setupPlayingSection];
  [self resetDrawButtonIfNeeded];
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

  leadingConstraint.active = TRUE;
  trailingConstraint.active = TRUE;
  topConstraint.active = TRUE;
  bottomConstraint.active = TRUE;
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

  bottomConstraint.active = TRUE;
  trailingConstraint.active = TRUE;
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

  bottomConstraint.active = TRUE;
  trailingConstraint.active = TRUE;
}

- (void)setupScoreTextConstraints:(UILabel *)textView {
  textView.translatesAutoresizingMaskIntoConstraints = NO;

  UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
  auto bottomConstraint = [textView.bottomAnchor
                           constraintEqualToAnchor:guide.bottomAnchor
                           constant:-edgeOffset];
  auto centerConstraint = [textView.centerXAnchor constraintEqualToAnchor:guide.centerXAnchor];

  bottomConstraint.active = TRUE;
  centerConstraint.active = TRUE;
}

// MARK: - Abstract

- (void)setupCardMatchingGame {
  [NSException raise:@"SetupCardMatchingGame should be overwritten."
              format:@"SetupCardMatchingGame is an abstract method, which should be overriden by all children."];
}

- (CardView *)generateCardView {
  [NSException raise:@"addCardViewAtIndex should be overwritten."
              format:@"addCardViewAtIndex is an abstract method, which should be overriden by all children."];
  return nil;
}

- (Card *)getCardForView:(CardView *)cardView {
  [NSException raise:@"GetCardForView should be overwritten."
              format:@"GetCardForView is an abstract method, which should be overriden by all children."];
  return nil;
}

@end

NS_ASSUME_NONNULL_END
