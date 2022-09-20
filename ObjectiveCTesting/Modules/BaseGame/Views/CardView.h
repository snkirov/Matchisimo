// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "UIKit/UIKit.h"

NS_ASSUME_NONNULL_BEGIN

/// Base class used to define the common behaviour for other `CardView` objects.
/// Repsonsible for drawing the frame and outline. Handles animations and selection.
@interface CardView : UIView

/// Shows whether the view is selected.
@property (nonatomic)BOOL selected;
/// Action to be triggered when the view is tapped.
@property (nonatomic)void (^didTapView)(void);
/// Animation option to be used when the user selects the view. It may be different from the animation for deselecting it.
@property (nonatomic, readonly)UIViewAnimationOptions animationOptionForTap;

/// Selects or deselects the `CardView` and updates it accordingly.
- (void)selectCard;

@end

NS_ASSUME_NONNULL_END
