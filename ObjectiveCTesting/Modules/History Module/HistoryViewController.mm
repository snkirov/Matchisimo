// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "HistoryViewController.h"
#import <UIKit/NSAttributedString.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistoryViewController()
@property (weak, nonatomic) IBOutlet UITextView *historyTextView;
@property (nonatomic, strong) NSMutableAttributedString *attributedHistory;
@end

@implementation HistoryViewController

- (void)setupWithAttributedHistory:(NSMutableAttributedString *)attributedHistory {
  _attributedHistory = attributedHistory;
  NSRange range;
  range.length = _attributedHistory.length;
  range.location = 0;
  auto paragraph = [[NSMutableParagraphStyle alloc] init];
  [paragraph setAlignment:NSTextAlignmentCenter];
  auto attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18],
                      NSParagraphStyleAttributeName: paragraph};
  [_attributedHistory addAttributes:attributes range:range];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self loadAttributedHistory];
}

- (void)loadAttributedHistory {
  if ([_attributedHistory.string isEqualToString:@""]) {
    _historyTextView.text = @"No history to show.";
  } else {
    [_historyTextView setAttributedText:_attributedHistory];
  }
}
@end

NS_ASSUME_NONNULL_END
