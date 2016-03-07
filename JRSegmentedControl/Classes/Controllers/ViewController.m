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

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.view.backgroundColor = [UIColor whiteColor];
	
	JRSegmentControl *segment = [[JRSegmentControl alloc] initWithFrame:CGRectMake(10, 100, SCREEN_W-20, 44)];
	segment.titles = @[@"选择一", @"选择二", @"选择三", @"选择四", @"选择五", @"选择六"];
	segment.itemBackgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
	segment.itemSelectedColor   = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
	segment.selectedTipColor	= [UIColor orangeColor];
	segment.selectedTipHeight	= 4;
	
	[self.view addSubview:segment];
}

@end
