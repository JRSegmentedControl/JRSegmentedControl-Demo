//
//  ViewController.m
//  JRSegmentedControl
//
//  Created by wxiao on 15/12/27.
//  Copyright © 2015年 wxiao. All rights reserved.
//

#import "ViewController.h"
#import "JRSegmentControl.h"


#define SCREEN_W ([UIScreen mainScreen].bounds.size.width)

@interface ViewController ()
@property (nonatomic, strong) JRSegmentControl	*segment;
@property (nonatomic, assign) NSInteger			index;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.view.backgroundColor = [UIColor whiteColor];
	
	JRSegmentControl *segment = [[JRSegmentControl alloc] initWithFrame:CGRectMake(10, 70, SCREEN_W-20, 44)];
	segment.titles = @[@"选择一", @"选择二", @"选择三", @"选择四", @"选择五五五", @"选择六", @"选择七", @"选择八"];
	segment.segmentWidthType	= JRSegmentItemFixedWidth;
	segment.itemBackgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
	segment.itemSelectedColor   = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
	segment.selectedTipColor	= [UIColor orangeColor];
	segment.selectedTipHeight	= 4;
	self.segment				= segment;
	[self.view addSubview:segment];
	
	JRSegmentControl *segment2 = [[JRSegmentControl alloc] initWithFrame:CGRectMake(10, 130, SCREEN_W-20, 40)];
	segment2.titles = @[@"选择", @"选择二", @"选择三1111"];
	segment2.segmentWidthType	= JRSegmentItemFixedWidthFull;
	segment2.itemBackgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
	segment2.itemSelectedColor   = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
	segment2.selectedTipColor	= [UIColor orangeColor];
	segment2.selectedTipHeight	= 4;
	self.segment				= segment2;
	[self.view addSubview:segment2];
	
	
	JRSegmentControl *segment3 = [[JRSegmentControl alloc] initWithFrame:CGRectMake(10, 190, SCREEN_W-20, 40)];
	segment3.titles = @[@"选择", @"选择二", @"选择三", @"选择", @"选择呜呜"];
	segment3.segmentWidthType	= JRSegmentItemDynamicWidth;
	segment3.itemBackgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
	segment3.itemSelectedColor   = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
	segment3.selectedTipColor	= [UIColor orangeColor];
	segment3.selectedTipHeight	= 4;
	self.segment				= segment3;
	[self.view addSubview:segment3];
	
	JRSegmentControl *segment4 = [[JRSegmentControl alloc] initWithFrame:CGRectMake(10, 240, SCREEN_W-20, 40)];
	segment4.titles = @[@"选择", @"选择二", @"选择三", @"选择", @"选择呜呜", @"选择三", @"选择", @"选择呜呜"];
	segment4.segmentWidthType	= JRSegmentItemFixedWidthFull;
	segment4.itemBackgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
	segment4.itemSelectedColor   = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
	segment4.selectedTipColor	= [UIColor orangeColor];
	segment4.selectedTipHeight	= 4;
	self.segment				= segment4;
	[self.view addSubview:segment4];
	
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

	NSInteger index = self.index % self.segment.titles.count;
	[self.segment setSegmentSelectedIndex:index animation:NO];
	NSLog(@"====== %zd -- %zd", self.segment.segmentSelectedIndex, self.index);
	self.index++;
}

@end
