// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "BaseGameViewController.h"
#import "BaseGameViewController+Protected.h"
#import "CardProtocol.h"
#import "CardMatchingGame.h"
#import "CardView.h"
#import "DeckFactory.h"
#import "Grid.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseGameViewController() <UIDynamicAnimatorDelegate>
/// Shows whether the screen is in the flow cards state.
/// This state can be entered and exited via a gesture and while it is active the game is paused.
@property (nonatomic) BOOL shouldFloatCards;
@property (nonatomic, strong) Grid *cardGrid;
@property (nonatomic) NSMutableArray<CardView *> *cardViews;
@property (nonatomic, strong) UIView *cardCanvas;
@property (nonatomic, strong) UIButton *drawButton;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIAttachmentBehavior *attachment;

@end

@implementation BaseGameViewController

static const CGFloat cellAspectRatio = 0.5625;
static const NSUInteger defaultCardCount = 12;
static const CGFloat edgeOffset = 20;

- (UIDynamicAnimator *)animator {
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        _animator.delegate = self;
    }
    return _animator;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupCardMatchingGame];
  [self initialGridSetup];
  [self setupPlayingSection];
  [self setupBottomBar];
  [self addGestures];
  [self.cardCanvas layoutIfNeeded];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  /// Responsible for reloading the screen on screen rotation.
  /// Also fixes a bug with the grid not using the updated frame of the card canvas, once the tabbar gets added.
  [self reloadScreenAnimated:FALSE];
}

// MARK: - Setup

- (void)initialGridSetup {
  self.cardGrid = [[Grid alloc] init];
  self.cardGrid.cellAspectRatio = cellAspectRatio;
  self.cardGrid.minCellWidth = 30;
  self.cardGrid.minCellHeight = 30 * 16 / 9;
}

- (void)setupPlayingSection {
  [self setupCardCanvas];
  [self evaluateDefaultGrid];
  [self setupCards];
  [self.view layoutIfNeeded];
}

- (void)setupCardCanvas {
  self.cardCanvas = [[UIView alloc] init];
  [self.view addSubview:self.cardCanvas];
  self.cardCanvas.backgroundColor = UIColor.clearColor;
  [self setupCardCanvasConstraints];
  [self.cardCanvas layoutIfNeeded];
}

- (void)evaluateDefaultGrid {
  // The size is evaluated here, since the cardCanvas needs to be initialised to use it's frame.
  self.cardGrid.size = self.cardCanvas.frame.size;
  self.cardGrid.minimumNumberOfCells = defaultCardCount;
}

- (void)setupCards {
  self.cardViews = [[NSMutableArray alloc] init];
  for (int i = 0; i < self.cardGrid.rowCount; i++) {
    for (int j = 0; j < self.cardGrid.columnCount; j++) {
      CardView *cardView = [self drawCardAndCreateView];
      auto frame = [self.cardGrid frameOfCellAtRow:i inColumn:j];
      [self drawCardViewWithRedrawAnimation:cardView withFrame:frame];
      [self addDidTapActionToCardView:cardView];
      [self.cardViews addObject:cardView];
      [self.cardCanvas addSubview:cardView];
      if ([self.cardViews count] == defaultCardCount) {
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
    if (strongSelf.shouldFloatCards) {
      [self reloadScreenAnimated:TRUE];
      return;
    }
    [strongSelf didTapCardView:strongCardView];
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
  self.scoreLabel = textView;
}

- (NSString *)getCurrentScoreString {
  auto scoreString = [[NSString alloc] initWithFormat:@"Score: %ld", (long)[self.cardMatchingGame score]];
  return scoreString;
}

- (void)setupButtons {
  [self setupDrawButton];
  [self setupRedealButton];
}

- (void)setupDrawButton {
  self.drawButton = [[UIButton alloc] init];
  [self.drawButton setTitle:@"Draw" forState:UIControlStateNormal];
  [self.drawButton setTitle:@"Deck Empty" forState:UIControlStateDisabled];
  [self.drawButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
  [self.drawButton addTarget:self action:@selector(didTapDraw:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.drawButton];
  [self setupDrawButtonConstraints:self.drawButton];
  [self.drawButton layoutIfNeeded];
}

- (void)didTapDraw:(UIButton *)button {
  [self drawMoreCards];
}

- (void)disableDrawButtonIfNeeded {
  if (!self.drawButton.isEnabled) {
    return;
  }
  [self.drawButton setEnabled:FALSE];
  [self.drawButton layoutIfNeeded];
}

- (void)resetDrawButtonIfNeeded {
  if (self.drawButton.isEnabled) {
    return;
  }
  [self.drawButton setEnabled:TRUE];
  [self.drawButton layoutIfNeeded];
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
  [self.cardMatchingGame chooseCard:card];
  [self updateUI];
  [self.view layoutIfNeeded];
}

// MARK: - Update

- (void)updateUI {
  // This is needed, since we can't modify an array which is being iterated over.
  NSArray<CardView *> *cardViewsCopy = [self.cardViews copy];
  for (CardView *cardView in cardViewsCopy) {
    [self updateCardView:cardView];
  }
  [self reloadScreenAnimated:TRUE];
  [self updateScore];
}

- (void)updateScore {
  self.scoreLabel.text = [self getCurrentScoreString];
}

- (void)updateCardView:(CardView *)cardView {
  auto card = [self getCardForView:cardView];

  if (card.isMatched) {
    [self removeCard:card andView:cardView];
    return;
  }

  if (card.isSelected) {
    [UIView transitionWithView:cardView
                      duration:0.3
                       options:cardView.animationOptionForTap
                    animations:^{
      [cardView setSelected:TRUE];
    } completion:nil];
    return;
  }

  if (cardView.selected)
  [UIView transitionWithView:cardView
                    duration:0.3
                     options:UIViewAnimationOptionTransitionCrossDissolve
                  animations:^{
    [cardView setSelected:FALSE];
  } completion:nil];
}

- (void)removeCard:(id <CardProtocol>)card andView:(CardView *)cardView {
  [cardView removeFromSuperview];
  [self.cardViews removeObject:cardView];
  [self.cardMatchingGame removeCard:card];
}

// MARK: - Reload

- (void)drawMoreCards {
  auto cardsPerDraw = 3;
  for (int i = 0; i < cardsPerDraw; i++) {
    auto cardView = [self drawCardAndCreateView];
    // Make the card appear from the bottom left corner
    cardView.frame = CGRectMake(0, self.cardCanvas.frame.size.height, 0, 0);
    [self addDidTapActionToCardView:cardView];
    [self.cardViews addObject:cardView];
    [self.cardCanvas addSubview:cardView];
    if (![self.cardMatchingGame canDrawMore]) {
      [self disableDrawButtonIfNeeded];
      break;
    }
  }
  [self reloadScreenAnimated:TRUE];
}

- (void)reloadScreenAnimated:(Boolean)isAnimated {
  self.shouldFloatCards = FALSE;
  [self reevaluateGrid];
  [self reloadCardsAnimated:isAnimated];
}

- (void)reevaluateGrid {
  /// When drawing new cards the first line is called even though it is not needed. No bad side effect.
  self.cardGrid.size = self.cardCanvas.frame.size;
  self.cardGrid.minimumNumberOfCells = self.cardViews.count;
}

- (void)reloadCardsAnimated:(Boolean)isAnimated {
  if (isAnimated) {
    [self reloadCardsAnimated];
  } else {
    [self reloadCardsNotAnimated];
  }
}

- (void)reloadCardsAnimated {
  for (int i = 0; i < self.cardViews.count; i++) {
    auto row = [self.cardGrid getRowForIndex:i];
    auto column = [self.cardGrid getColumnForIndex:i];
    [UIView animateWithDuration:1.0 animations:^{
      self.cardViews[i].frame = [self.cardGrid frameOfCellAtRow:row inColumn:column];
    }];
  }
  [self.cardCanvas layoutSubviews];
}

- (void)reloadCardsNotAnimated {
  for (int i = 0; i < self.cardViews.count; i++) {
    auto row = [self.cardGrid getRowForIndex:i];
    auto column = [self.cardGrid getColumnForIndex:i];
    self.cardViews[i].frame = [self.cardGrid frameOfCellAtRow:row inColumn:column];
  }
  [self.cardCanvas layoutSubviews];
}

- (void)redealGame {
  [self.cardCanvas removeFromSuperview];
  [self setupCardMatchingGame];
  [self updateScore];
  [self setupPlayingSection];
  [self resetDrawButtonIfNeeded];
}

// MARK: - Gestures

- (void)addGestures {
  [self addPinchGesture];
  [self addDoubleTapGesture];
  [self addPanGesture];
}

- (void)addPinchGesture {
  auto pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(userDidPinch:)];
  [self.view addGestureRecognizer:pinchGesture];
}

- (void)addDoubleTapGesture {
  auto tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidDoubleTap:)];
  tapGesture.numberOfTapsRequired = 2;
  [self.view addGestureRecognizer:tapGesture];
}

- (void)addPanGesture {
  auto panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(userDidPan:)];
  [self.view addGestureRecognizer:panGesture];
}

- (void)userDidPinch:(UIPinchGestureRecognizer *)selector {
  if (self.shouldFloatCards) {
    return;
  }
  self.shouldFloatCards = TRUE;
  for (CardView *cardView in self.cardViews) {
    [UIView animateWithDuration:1.0 animations:^{
      [cardView setCenter:[selector locationInView:self.view]];
    }];
  }
}

- (void)userDidPan:(UIPanGestureRecognizer *)selector {
  if (!self.shouldFloatCards || self.cardViews.count == 0) {
    return;
  }
  CGPoint gesturePoint = [selector locationInView:self.view];
  auto attachedCardView = self.cardViews[0];
  if (selector.state == UIGestureRecognizerStateBegan) {
    [self createAttachmentBehvaiourForCardView:attachedCardView atAnchor:gesturePoint];
  } else if (selector.state == UIGestureRecognizerStateChanged) {
    [self changedPanGestureForAttachedCardView:attachedCardView movedToPoint:gesturePoint];
  } else if (selector.state == UIGestureRecognizerStateEnded) {
    [self endPanGestureForAttachedCardView:attachedCardView];
  }
}

- (void)createAttachmentBehvaiourForCardView:(CardView *)attachedCardView atAnchor:(CGPoint)gesturePoint {
  self.attachment = [[UIAttachmentBehavior alloc] initWithItem:attachedCardView attachedToAnchor:gesturePoint];
  [self.animator addBehavior:self.attachment];
}

- (void)changedPanGestureForAttachedCardView:(CardView *)attachedCardView movedToPoint:(CGPoint)gesturePoint {
  self.attachment.anchorPoint = gesturePoint;
  auto delayIncr = 0.0;
  for (CardView *cardView in self.cardViews) {
    [UIView animateWithDuration:0.1 delay:delayIncr options:UIViewAnimationOptionCurveEaseIn animations:^{
      [cardView setCenter:attachedCardView.center];
    } completion:nil];
    delayIncr += 0.01;
  }
}

- (void)endPanGestureForAttachedCardView:(CardView *)attachedCardView {
  [self.animator removeBehavior:self.attachment];
  for (CardView *cardView in self.cardViews) {
    [cardView setCenter:attachedCardView.center];
  }
}

- (void)userDidDoubleTap:(UITapGestureRecognizer *)selector {
  if (!self.shouldFloatCards) {
    return;
  }
  [self reloadScreenAnimated:TRUE];
}

// MARK: - Constraints
- (void)setupCardCanvasConstraints {
  self.cardCanvas.translatesAutoresizingMaskIntoConstraints = NO;

  UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
  auto bottomOffset = self.view.frame.size.height / 8;
  auto leadingConstraint = [self.cardCanvas.leadingAnchor
                            constraintEqualToAnchor:guide.leadingAnchor
                            constant:edgeOffset];
  auto trailingConstraint = [self.cardCanvas.trailingAnchor
                             constraintEqualToAnchor:guide.trailingAnchor
                             constant:-edgeOffset];
  auto topConstraint = [self.cardCanvas.topAnchor
                        constraintEqualToAnchor:guide.topAnchor
                        constant:edgeOffset];
  auto bottomConstraint = [self.cardCanvas.bottomAnchor
                           constraintEqualToAnchor:guide.bottomAnchor
                           constant:-bottomOffset];

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
                           constant:-edgeOffset];
  auto leadingConstraint = [redealButton.leadingAnchor
                           constraintGreaterThanOrEqualToAnchor:self.scoreLabel.trailingAnchor
                           constant:10];
  auto trailingConstraint = [redealButton.trailingAnchor
                             constraintEqualToAnchor:guide.trailingAnchor
                             constant:-edgeOffset];


  bottomConstraint.active = TRUE;
  leadingConstraint.active = TRUE;
  trailingConstraint.active = TRUE;
}

- (void)setupDrawButtonConstraints:(UIButton *)drawButton {
  drawButton.translatesAutoresizingMaskIntoConstraints = NO;

  UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
  auto bottomConstraint = [drawButton.bottomAnchor
                           constraintEqualToAnchor:guide.bottomAnchor
                           constant:-edgeOffset];
  auto leadingConstraint = [drawButton.leadingAnchor
                             constraintEqualToAnchor:guide.leadingAnchor
                             constant:edgeOffset];
  auto trailingConstraint = [self.scoreLabel.leadingAnchor
                           constraintGreaterThanOrEqualToAnchor:drawButton.trailingAnchor
                           constant:10];

  bottomConstraint.active = TRUE;
  leadingConstraint.active = TRUE;
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
              format:@"SetupCardMatchingGame is an abstract method, which should be overwritten by all children."];
}

- (nullable CardView *)drawCardAndCreateView {
  [NSException raise:@"drawCardAndCreateView should be overwritten."
              format:@"drawCardAndCreateView is an abstract method, which should be overwritten by all children."];
  return nil;
}

- (nullable id <CardProtocol>)getCardForView:(CardView *)cardView {
  [NSException raise:@"GetCardForView should be overwritten."
              format:@"GetCardForView is an abstract method, which should be overwritten by all children."];
  return nil;
}

@end

NS_ASSUME_NONNULL_END
