// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "CardView.h"

#ifndef ObjectiveCTesting____FILEBASENAMEASIDENTIFIER_______FILEEXTENSION___
#define ObjectiveCTesting____FILEBASENAMEASIDENTIFIER_______FILEEXTENSION___

@interface CardView()
/// Animation option to be used when the user selects the view. It may be different from the animation for deselecting it.
@property (nonatomic, readonly)UIViewAnimationOptions animationOptionForTap;
/// ScaleFactor used for corner radius and corner text.
- (CGFloat)cornerScaleFactor;
/// The corner radius to be used. Scales to view size.
- (CGFloat)cornerRadius;
/// Draws the interior of the card.
/// Each `CardView` subclass is responsible for overwritting this method.
- (void)drawCardInterior;
@end

#endif
