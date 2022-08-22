// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface HistoryViewController : UIViewController
- (void)setupWithAttributedHistory:(NSMutableAttributedString *)attributedHistory;
- (void)setupWithHistory:(NSString *)history;
@end

NS_ASSUME_NONNULL_END
