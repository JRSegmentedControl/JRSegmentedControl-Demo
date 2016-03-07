//
//  JRSegmentControl.m
//  JRSegmentedControl
//
//  Created by 王潇 on 16/3/7.
//  Copyright © 2016年 wxiao. All rights reserved.
//

#import "JRSegmentControl.h"


@interface JRScrollView : UIScrollView
@end

@implementation JRScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!self.dragging) {
		[self.nextResponder touchesBegan:touches withEvent:event];
	} else {
		[super touchesBegan:touches withEvent:event];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	if (!self.dragging) {
		[self.nextResponder touchesMoved:touches withEvent:event];
	} else{
		[super touchesMoved:touches withEvent:event];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!self.dragging) {
		[self.nextResponder touchesEnded:touches withEvent:event];
	} else {
		[super touchesEnded:touches withEvent:event];
	}
}

@end


@interface JRSegmentControl ()
@property (nonatomic, strong) JRScrollView		*scrollView;					// scrollView
@property (nonatomic, assign) NSInteger			countOfItems;					// Item数量
// -----
@property (nonatomic, strong) NSMutableArray	*itemSizes;						// 每个项目的Size
@property (nonatomic, strong) NSMutableArray	*itemFrames;					// 每个项目的Frame
@property (nonatomic, strong) NSMutableArray	*backFrames;					// Item 背景 Layer
@property (nonatomic, strong) NSMutableArray	*tipFrames;						// Item tip Frame

@property (nonatomic, assign) double			totleWidth;						// 总宽度
@property (nonatomic, assign) double			totleHeight;					// 总高度
@property (nonatomic, assign) CGFloat			maxWidth;						// Item 最大宽度

@property (nonatomic, strong) NSDictionary		*titleTextAttributes;			// 正常文本属性
@property (nonatomic, strong) NSDictionary		*titleTextAttributesSelected;	// 选中文本属性

@property (nonatomic, strong) CALayer			*selectionIndicatorStripLayer;	// 选中标识
@property (nonatomic, strong) CALayer			*backgroundLayer;				// 背景

@property (nonatomic, assign) CGRect			proRect;						// 前一个Item Frame
@end

@implementation JRSegmentControl

#pragma mark - Initialize
- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithTitles:(NSArray *)titles {
	if (self = [super initWithFrame:CGRectZero]) {
		self.backgroundColor = [UIColor orangeColor];
		[self commonInit];
		self.titles = titles;
	}
	return self;
}

- (void)commonInit {
	
	// 1. scrollView
	self.scrollView = [[JRScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
	self.scrollView.scrollsToTop					= NO;						//
	self.scrollView.showsVerticalScrollIndicator	= NO;
	self.scrollView.showsHorizontalScrollIndicator	= NO;
	[self addSubview:self.scrollView];
	// 2. Size 数组
	self.itemSizes = [[NSMutableArray alloc] init];
	
	// 3. Rect 数组
	self.itemFrames = [[NSMutableArray alloc] init];
	
	// 4. backgroundColor
	self.backgroundColor = [UIColor whiteColor];
	
	// 5. Segment 宽度类似
	self.segmentWidthType = JRSegmentItemDynamicWidth;
	
	// 6. 选中标识
	self.selectionIndicatorStripLayer = [CALayer layer];
	self.backgroundLayer = [CALayer layer];
	
	self.selectedTipHeight = 2;
	self.itemMargin = 10;
	
	self.backFrames = [NSMutableArray array];
	self.tipFrames  = [NSMutableArray array];
	
	// Color
	self.itemBackgroundColor = [UIColor whiteColor];
	self.itemSelectedColor   = [UIColor whiteColor];
}

#pragma mark - 属性设置
- (void)setBackgroundColor:(UIColor *)backgroundColor {
	_backgroundColor = backgroundColor;
	self.scrollView.backgroundColor = backgroundColor;
}

- (void)setFrame:(CGRect)frame {
	_frame = frame;
	super.frame = frame;
}

- (void)setTitles:(NSArray *)titles {
	_titles = titles;
	self.proRect = CGRectZero;
	[self updateSegmentsRects];
}

- (void)setItemBackgroundColor:(UIColor *)itemBackgroundColor {
	_itemBackgroundColor = itemBackgroundColor;
	self.scrollView.backgroundColor = self.itemBackgroundColor;
}

- (void)setItemSelectedColor:(UIColor *)itemSelectedColor {
	_itemSelectedColor = itemSelectedColor;
}

- (void)setSelectedTipColor:(UIColor *)selectedTipColor {
	_selectedTipColor = selectedTipColor;
}

- (void)setSelectedTipHeight:(CGFloat)selectedTipHeight {
	_selectedTipHeight = selectedTipHeight;
	[self updateSegmentsRects];
}

#pragma mark - 更新 Items 布局
- (void)updateSegmentsRects {
	
	// 0. 清楚数据
	[self.itemSizes  removeAllObjects];
	[self.itemFrames removeAllObjects];
	[self.backFrames removeAllObjects];
	[self.tipFrames  removeAllObjects];
	
	switch (self.segmentWidthType) {
		case JRSegmentItemFixedWidth:
			[self updateWithItemFixedWidth];
			break;
		case JRSegmentItemFixedWidthFull:
			[self updateWithItemFixedWidthFull];
			break;
		case JRSegmentItemDynamicWidth:
			[self updateWithItemDynamicWidth];
			break;
		case JRSegmentItemDynamicWidthFull:
			[self updateWithItemDynamicWidthFull];
			break;
		default:
			[self updateWithItemFixedWidth];
			break;
	}
	
	// 4. titles 总宽度
	CGRect frame = [[self.itemFrames lastObject] CGRectValue];
	self.totleWidth = CGRectGetMaxX(frame);
	if (self.totleWidth <= self.frame.size.width) {
		self.scrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
	} else {
		self.scrollView.contentSize = CGSizeMake(self.totleWidth, self.frame.size.height);
	}
	
	[self setNeedsDisplay];
}

// JRSegmentItemFixedWidth
- (void)updateWithItemFixedWidth {
	// 1. 计算 itemSizes
	for (int i=0; i<self.titles.count; i++) {
		CGSize size = [self sizeOfTitleAtIndex:i];
		size.width  += self.itemMargin;											// size 宽度 + margin
		[self.itemSizes addObject:[NSValue valueWithCGSize:size]];
	}
	
	// 2. 计算itemFrames
	self.proRect = CGRectZero;
	for (int i = 0; i < self.titles.count; i++) {
		CGFloat itemX	= CGRectGetMaxX(self.proRect);
		CGSize size		= [self.itemSizes[i] CGSizeValue];
		CGFloat itemY	= 0.0;
		if (self.frame.size.height > size.height) {
			itemY = (self.frame.size.height - size.height) * 0.5;
		}
		CGRect frame	= CGRectMake(itemX, itemY, size.width, size.height);
		CGRect backF	= CGRectMake(itemX, 0, size.width, self.frame.size.height);
		self.proRect	= frame;
		[self.itemFrames addObject:[NSValue valueWithCGRect:frame]];
		[self.backFrames addObject:[NSValue valueWithCGRect:backF]];
	}
	
	// 3. TipFrame
	for (int i = 0; i < self.titles.count; i++) {
		CGRect frame = [self.backFrames[i] CGRectValue];
		CGFloat tipY = frame.size.height - self.selectedTipHeight;
		CGRect tipFame = CGRectMake(frame.origin.x, tipY, frame.size.width ,self.selectedTipHeight);
		[self.tipFrames addObject:[NSValue valueWithCGRect:tipFame]];
	}
}

- (void)updateWithItemFixedWidthFull {
	// 1. 计算 itemSizes
	self.maxWidth = 0.0;
	for (int i=0; i<self.titles.count; i++) {
		CGSize size = [self sizeOfTitleAtIndex:i];
		size.width  += self.itemMargin;											// size 宽度 + margin
		[self.itemSizes addObject:[NSValue valueWithCGSize:size]];
		if (self.maxWidth < size.width) {
			self.maxWidth = size.width;
		}
	}
	
	if (self.maxWidth * self.titles.count < self.frame.size.width) {
		self.maxWidth = self.frame.size.width / self.titles.count;
		for (int i = 0; i < self.itemSizes.count; i++) {
			CGSize size = [self.itemSizes[i] CGSizeValue];
			size.width = self.maxWidth;
			[self.itemSizes replaceObjectAtIndex:i withObject:[NSValue valueWithCGSize:size]];
		}
	}
	
	// 2. 计算itemFrames
	self.proRect = CGRectZero;
	for (int i = 0; i < self.titles.count; i++) {
		CGFloat itemX	= CGRectGetMaxX(self.proRect);
		CGSize size		= [self.itemSizes[i] CGSizeValue];
		CGFloat itemY	= 0.0;
		if (self.frame.size.height > size.height) {
			itemY = (self.frame.size.height - size.height) * 0.5;
		}
		CGRect frame	= CGRectMake(itemX, itemY, size.width, size.height);
		CGRect backF	= CGRectMake(itemX, 0, size.width, self.frame.size.height);
		self.proRect	= frame;
		[self.itemFrames addObject:[NSValue valueWithCGRect:frame]];
		[self.backFrames addObject:[NSValue valueWithCGRect:backF]];
	}
	
	// 3. TipFrame
	for (int i = 0; i < self.titles.count; i++) {
		CGRect frame = [self.backFrames[i] CGRectValue];
		CGFloat tipY = frame.size.height - self.selectedTipHeight;
		CGRect tipFame = CGRectMake(frame.origin.x, tipY, frame.size.width ,self.selectedTipHeight);
		[self.tipFrames addObject:[NSValue valueWithCGRect:tipFame]];
	}
}

- (void)updateWithItemDynamicWidth {
	// 1. 计算 itemSizes
	self.maxWidth = 0.0;
	for (int i=0; i<self.titles.count; i++) {
		CGSize size = [self sizeOfTitleAtIndex:i];
		size.width  += self.itemMargin;											// size 宽度 + margin
		[self.itemSizes addObject:[NSValue valueWithCGSize:size]];
		if (self.maxWidth < size.width) {
			self.maxWidth = size.width;
		}
	}
	
	for (int i = 0; i < self.itemSizes.count; i++) {
		CGSize size = [self.itemSizes[i] CGSizeValue];
		size.width = self.maxWidth;
		[self.itemSizes replaceObjectAtIndex:i withObject:[NSValue valueWithCGSize:size]];
	}
	
	// 2. 计算itemFrames
	self.proRect = CGRectZero;
	for (int i = 0; i < self.titles.count; i++) {
		CGFloat itemX	= CGRectGetMaxX(self.proRect);
		CGSize size		= [self.itemSizes[i] CGSizeValue];
		CGFloat itemY	= 0.0;
		if (self.frame.size.height > size.height) {
			itemY = (self.frame.size.height - size.height) * 0.5;
		}
		CGRect frame	= CGRectMake(itemX, itemY, size.width, size.height);
		CGRect backF	= CGRectMake(itemX, 0, size.width, self.frame.size.height);
		self.proRect	= frame;
		[self.itemFrames addObject:[NSValue valueWithCGRect:frame]];
		[self.backFrames addObject:[NSValue valueWithCGRect:backF]];
	}
	
	// 3. TipFrame
	for (int i = 0; i < self.titles.count; i++) {
		CGRect frame = [self.backFrames[i] CGRectValue];
		CGFloat tipY = frame.size.height - self.selectedTipHeight;
		CGRect tipFame = CGRectMake(frame.origin.x, tipY, frame.size.width ,self.selectedTipHeight);
		[self.tipFrames addObject:[NSValue valueWithCGRect:tipFame]];
	}
}

- (void)updateWithItemDynamicWidthFull {
	// 1. 计算 itemSizes
	self.maxWidth = 0.0;
	for (int i=0; i<self.titles.count; i++) {
		CGSize size = [self sizeOfTitleAtIndex:i];
		size.width  += self.itemMargin;											// size 宽度 + margin
		[self.itemSizes addObject:[NSValue valueWithCGSize:size]];
		if (self.maxWidth < size.width) {
			self.maxWidth = size.width;
		}
	}
	
	if (self.maxWidth * self.titles.count < self.frame.size.width) {
				self.maxWidth = self.frame.size.width / self.titles.count;
		for (int i = 0; i < self.itemSizes.count; i++) {
			CGSize size = [self.itemSizes[i] CGSizeValue];
			size.width = self.maxWidth;
			[self.itemSizes replaceObjectAtIndex:i withObject:[NSValue valueWithCGSize:size]];
		}
	}
	
	// 2. 计算itemFrames
	self.proRect = CGRectZero;
	for (int i = 0; i < self.titles.count; i++) {
		CGFloat itemX	= CGRectGetMaxX(self.proRect);
		CGSize size		= [self.itemSizes[i] CGSizeValue];
		CGFloat itemY	= 0.0;
		if (self.frame.size.height > size.height) {
			itemY = (self.frame.size.height - size.height) * 0.5;
		}
		CGRect frame	= CGRectMake(itemX, itemY, size.width, size.height);
		CGRect backF	= CGRectMake(itemX, 0, size.width, self.frame.size.height);
		self.proRect	= frame;
		[self.itemFrames addObject:[NSValue valueWithCGRect:frame]];
		[self.backFrames addObject:[NSValue valueWithCGRect:backF]];
	}
	
	// 3. TipFrame
	for (int i = 0; i < self.titles.count; i++) {
		CGRect frame = [self.backFrames[i] CGRectValue];
		CGFloat tipY = frame.size.height - self.selectedTipHeight;
		CGRect tipFame = CGRectMake(frame.origin.x, tipY, frame.size.width ,self.selectedTipHeight);
		[self.tipFrames addObject:[NSValue valueWithCGRect:tipFame]];
	}
}

#pragma mark - drawRect
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	self.scrollView.layer.sublayers = nil;
	self.scrollView.contentInset	= UIEdgeInsetsZero;
	
	for (int i = 0; i < self.titles.count; ++i) {
		CATextLayer *titleLayer		= [CATextLayer layer];
		CGRect frame				= [self.itemFrames[i] CGRectValue];
		titleLayer.frame			= frame;
		titleLayer.alignmentMode	= kCAAlignmentCenter;
		titleLayer.truncationMode	= kCATruncationEnd;
		titleLayer.string			= [self attributedTitleAtIndex:i];
		titleLayer.contentsScale	= [[UIScreen mainScreen] scale];
		[self.scrollView.layer addSublayer:titleLayer];
	}
	
	[CATransaction begin];
	[CATransaction setAnimationDuration:0.25f];
	
	CGRect tipFrame = [self.tipFrames[self.segmentSelectedIndex] CGRectValue];
	self.selectionIndicatorStripLayer.backgroundColor = self.selectedTipColor.CGColor;
	self.selectionIndicatorStripLayer.frame			  = tipFrame;
	[self.scrollView.layer addSublayer:self.selectionIndicatorStripLayer];
	
	CGRect frame = [self.backFrames[self.segmentSelectedIndex] CGRectValue];
	self.backgroundLayer.backgroundColor	= self.itemSelectedColor.CGColor;
	self.backgroundLayer.frame				= frame;
	[self.scrollView.layer insertSublayer:self.backgroundLayer atIndex:0];
	
	[CATransaction commit];
}

#pragma mark - Calc Size
// 根据索引回去文本, 并计算文本的 Size
- (CGSize)sizeOfTitle:(NSString *)title {
	
	CGSize size		= CGSizeZero;
	if ([title isKindOfClass:[NSString class]]) {
		
		if ([self.titles[self.segmentSelectedIndex] isEqualToString:title]) {
			size = [(NSString *)title sizeWithAttributes:self.titleTextAttributesSelected];
		} else {
			size = [(NSString *)title sizeWithAttributes:self.titleTextAttributes];
		}
	}
	return CGRectIntegral((CGRect){CGPointZero, size}).size;
}

// 根据索引回去文本, 并计算文本的 Size
- (CGSize)sizeOfTitleAtIndex:(NSUInteger)index {
	id title		= self.titles[index];										// 获取 Item
	CGSize size		= CGSizeZero;
	if ([title isKindOfClass:[NSString class]]) {
		if (self.segmentSelectedIndex == index) {
			size = [(NSString *)title sizeWithAttributes:self.titleTextAttributesSelected];
		} else {
			size = [(NSString *)title sizeWithAttributes:self.titleTextAttributes];
		}
	}
	return CGRectIntegral((CGRect){CGPointZero, size}).size;
}

#pragma mark - 文字属性
// 普通文本属性
- (NSAttributedString *)attributedTitleAtIndex:(NSUInteger)index {
	id title = self.titles[index];
	
	if (index == self.segmentSelectedIndex) {
		return [[NSAttributedString alloc] initWithString:(NSString *)title attributes:self.titleTextAttributesSelected];
	}
	return [[NSAttributedString alloc] initWithString:(NSString *)title attributes:self.titleTextAttributes];
}
// 默认普通文本属性
- (NSDictionary *)titleTextAttributes {
	if (_titleTextAttributes) {
		return _titleTextAttributes;
	}
	NSDictionary *defaults = @{
							   NSFontAttributeName : [UIFont systemFontOfSize:18.0f],
							   NSForegroundColorAttributeName : [UIColor whiteColor],
							   };
	return _titleTextAttributes = [NSMutableDictionary dictionaryWithDictionary:defaults].copy;
}
// 选中状态文本属性
- (NSDictionary *)titleTextAttributesSelected {
	if (_titleTextAttributesSelected) {
		return _titleTextAttributesSelected;
	}
	
	NSDictionary *defaults = @{
							   NSFontAttributeName : [UIFont systemFontOfSize:20.0f],
							   NSForegroundColorAttributeName : [UIColor blackColor],
							   };
	return _titleTextAttributesSelected = [NSMutableDictionary dictionaryWithDictionary:defaults].copy;
}

#pragma mark - 

- (void)setSegmentSelectedIndex:(NSInteger)segmentSelectedIndex {
	_segmentSelectedIndex = segmentSelectedIndex;
	[self updateSegmentsRects];
	[self scrollViewMoveToCenterWithAnimation:YES];
}

- (void)setSegmentSelectedIndex:(NSInteger)segmentSelectedIndex animation:(BOOL)animation {
	_segmentSelectedIndex = segmentSelectedIndex;
	[self updateSegmentsRects];
	[self scrollViewMoveToCenterWithAnimation:animation];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch		  = [touches anyObject];
	CGPoint touchLocation = [touch locationInView:self.scrollView];
	
	for (int i = 0; i < self.backFrames.count; i++) {
		CGRect frame = [self.backFrames[i] CGRectValue];
		if (CGRectContainsPoint(frame, touchLocation)) {
			self.segmentSelectedIndex = i;
			break;
		}
	}
	[self scrollViewMoveToCenterWithAnimation:YES];
}

- (void)scrollViewMoveToCenterWithAnimation:(BOOL)animation {
	CGRect frame = [self.backFrames[self.segmentSelectedIndex] CGRectValue];
	
	if (frame.size.width < self.frame.size.width) {
		CGFloat itemX = frame.origin.x - (self.frame.size.width - frame.size.width) * 0.5;
		CGFloat itemW = self.frame.size.width;
		if (itemX < 0) {
			itemX = 0;
		}
		
		if ((itemX + itemW) > self.scrollView.contentSize.width) {
			itemW = self.scrollView.contentSize.width - itemX;
		}
		
		CGRect newFrame = CGRectMake(itemX, 0, itemW, 1);
		[self.scrollView scrollRectToVisible:newFrame animated:animation];
	} else {
		
		CGFloat itemX = frame.origin.x + (frame.size.width - self.frame.size.width) * 0.5;
		CGRect newFrame = CGRectMake(itemX, 0, self.frame.size.width, 1);
		[self.scrollView scrollRectToVisible:newFrame animated:animation];
	}
}

@end


