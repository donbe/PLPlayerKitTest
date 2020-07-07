//
//  SpectrumScrollView.h
//  ffttest
//
//  Created by donbe on 2020/6/29.
//  Copyright © 2020 donbe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpectrumScrollView : UIScrollView

-(void)setdata:(NSArray *)data;


/// 缩放因子，默认0.5，数字变大，图被拉升
@property(nonatomic) float scale;

@end

NS_ASSUME_NONNULL_END
