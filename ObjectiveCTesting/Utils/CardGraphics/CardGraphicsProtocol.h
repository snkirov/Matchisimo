// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

NS_ASSUME_NONNULL_BEGIN

@protocol CardGraphicsProtocol <NSObject>

- (CGContext)drawCard:(Card *)card inContext:(CGContext *)context;

@end

NS_ASSUME_NONNULL_END
