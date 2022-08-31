// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import <UIKit/UIKit.h>
#import "SetCardUtil.h"
NS_ASSUME_NONNULL_BEGIN

@interface SetCardView : UIView

// Is it better to expose all of the properties or just expose the underlying object?
@property (nonatomic)CARD_Shape shape;
@property (nonatomic)CARD_Color color;
@property (nonatomic)CARD_Fill fill;
@property (nonatomic)CARD_NumberOfShapes numberOfShapes;

@property (nonatomic) BOOL faceUp;

@end

NS_ASSUME_NONNULL_END
