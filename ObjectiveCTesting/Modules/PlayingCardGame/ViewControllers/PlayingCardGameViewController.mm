// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "PlayingCardGameViewController.h"
#import "SetCardView.h"
#import "SetCardUtil.h"
#import "Grid.h"
#import "DeckFactory.h"
#import "Deck.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayingCardGameViewController()
@property (nonatomic, strong)UIView *cardCanvas;
@property (nonatomic, strong)Grid *cardGrid;
@property (nonatomic)NSMutableArray<CardView *> *cards;
@property (nonatomic, strong)Deck *cardDeck;
@end

@implementation PlayingCardGameViewController

static const CGFloat cellAspectRatio = 0.5625;
static const NSUInteger defaultCardCount = 12;
static const CGFloat edgeOffset = 20;

- (void)viewDidLoad {
  [super viewDidLoad];
  [self initialGridSetup];
  [self setupPlayingSection];
  [self setupBottomBar];
  [self.cardCanvas layoutIfNeeded];
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
}

- (void)setupCards {
  _cards = [[NSMutableArray alloc] init];
  LogDebug(@"%@", _cardGrid);
  _cardDeck = [DeckFactory generateDeckWithSetCards];
  for (int j = 0; j < _cardGrid.rowCount; j++) {
    for (int i = 0; i < _cardGrid.columnCount; i++) {
      auto frame = [_cardGrid frameOfCellAtRow:j inColumn:i];
      auto cardView = [[SetCardView alloc] initWithFrame:frame];
      cardView.backgroundColor = UIColor.clearColor;
      auto setCard = (SetCard *)[_cardDeck drawRandomCard];
      [cardView setupWithSetCard:setCard];
      [_cards addObject:cardView];
      [_cardCanvas addSubview:cardView];
      if ([_cards count] == defaultCardCount) {
        return;
      }
    }
  }
  [self.cardCanvas layoutIfNeeded];
}

- (void)setupBottomBar {
  [self setupScoreText];
  [self setupButtons];
}

- (void)setupScoreText {
  auto textView = [[UILabel alloc] init];
  textView.text = @"Score: 100";
  [self.view addSubview:textView];
  [self setupScoreTextConstraints:textView];
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
}

- (void)didTapRedeal {
  [self resetScreen];
}

// MARK: - Reloading

- (void)drawThreeMoreCards {
  for (int i = 0; i < 3; i++) {
    auto cardView = [[SetCardView alloc] init];
    cardView.backgroundColor = UIColor.clearColor;
    auto setCard = (SetCard *)[_cardDeck drawRandomCard];
    [cardView setupWithSetCard:setCard];
    [_cards addObject:cardView];
    [_cardCanvas addSubview:cardView];
  }
  [self reloadScreen];
}

- (void)reloadScreen {
  [self reevaluateGrid];
  [self reloadCards];
}

- (void)reevaluateGrid {
  // TODO: When adding three new cards this line is called even though it is not needed.
  _cardGrid.size = _cardCanvas.frame.size;
  _cardGrid.minimumNumberOfCells = _cards.count;
  LogDebug(@"%@", _cardGrid);
}

- (void)reloadCards {
  for (int i = 0; i < _cards.count; i++) {
    auto row = i / _cardGrid.columnCount;
    auto column = i % _cardGrid.columnCount;
    _cards[i].frame = [_cardGrid frameOfCellAtRow:row inColumn:column];
  }
  [_cardCanvas layoutSubviews];
}

- (void)resetScreen {
  [self.cardCanvas removeFromSuperview];
  [self setupPlayingSection];
}

// MARK: - Screen Rotation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
  __weak typeof(self) weakSelf = self;
  [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    __strong typeof(self) strongSelf = weakSelf;
    [strongSelf reloadScreen];
  }
                               completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {}];
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
  [self.cardCanvas layoutIfNeeded];
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
  [redealButton layoutIfNeeded];
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
  [drawButton layoutIfNeeded];
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
  [textView layoutIfNeeded];
}
@end

NS_ASSUME_NONNULL_END
