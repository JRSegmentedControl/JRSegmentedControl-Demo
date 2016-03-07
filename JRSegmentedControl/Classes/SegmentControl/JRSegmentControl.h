//
//  JRSegmentControl.h
//  JRSegmentedControl
//
//  Created by 王潇 on 16/3/7.
//  Copyright © 2016年 wxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
	JRSegmentItemFixedWidth,
	JRSegmentItemFixedWidthFull,
	JRSegmentItemDynamicWidth,
	JRSegmentItemDynamicWidthFull
} JRSegmentItemWidthType;

@interface JRSegmentControl : UIControl

// 设置数组
@property (nonatomic, strong) NSArray *titles;

// 设置Frame
@property (nonatomic, assign) CGRect frame;

// 背景色
@property (nonatomic, strong) UIColor *backgroundColor;

// Item 宽度样式
@property (nonatomic, assign) JRSegmentItemWidthType segmentWidthType;

// 当前选择项
@property (nonatomic, assign) NSInteger segmentSelectedIndex;

// Item 间隔 默认是 10
@property (nonatomic, assign) CGFloat itemMargin;

// tip 标志高度
@property (nonatomic, assign) CGFloat selectedTipHeight;

//
@property (nonatomic, strong) UIColor *itemBackgroundColor;
//
@property (nonatomic, strong) UIColor *itemSelectedColor;
//
@property (nonatomic, strong) UIColor *selectedTipColor;


/**
 *  初始化
 *
 *  @param titles titles
 *
 *  @return 返回 JRSegmentControl
 */
- (instancetype)initWithTitles:(NSArray *)titles;

@end
