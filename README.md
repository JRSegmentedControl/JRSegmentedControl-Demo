# JRSegmentedControl-Demo
##SegmentedControl

###HMSegmentedControl

######自定义类型


#####枚举类型
```Objective-C
/// 选择标记样式
typedef enum {
    HMSegmentedControlSelectionStyleTextWidthStripe,    // 
    HMSegmentedControlSelectionStyleFullWidthStripe,    // 
    HMSegmentedControlSelectionStyleBox,                // 
    HMSegmentedControlSelectionStyleArrow               //
} HMSegmentedControlSelectionStyle;

/// 选择标记位置
typedef enum {
    HMSegmentedControlSelectionIndicatorLocationUp,     // Segment 上方
    HMSegmentedControlSelectionIndicatorLocationDown,   // Segment 下方
	  HMSegmentedControlSelectionIndicatorLocationNone    // No selection indicator
} HMSegmentedControlSelectionIndicatorLocation;

/// 布局方式
typedef enum {
    HMSegmentedControlSegmentWidthStyleFixed,           // Segment width is fixed
    HMSegmentedControlSegmentWidthStyleDynamic,         // Segment width will only be as big as the text width (including inset)
} HMSegmentedControlSegmentWidthStyle;

/// 边框
typedef NS_OPTIONS(NSInteger, HMSegmentedControlBorderType) {
    HMSegmentedControlBorderTypeNone = 0,               // 无边框
    HMSegmentedControlBorderTypeTop = (1 << 0),         // 上边框
    HMSegmentedControlBorderTypeLeft = (1 << 1),        // 左边框
    HMSegmentedControlBorderTypeBottom = (1 << 2),      // 下边框
    HMSegmentedControlBorderTypeRight = (1 << 3)        // 右边框
};

enum {
    HMSegmentedControlNoSegment = -1                    // Segment index for no selected segment
};

/// Segment类型
typedef enum {
    HMSegmentedControlTypeText,                         // 文本
    HMSegmentedControlTypeImages,                       // 图片
	  HMSegmentedControlTypeTextImages                    // 文本&图片
} HMSegmentedControlType;
```

#####属性说明
```Objective-C
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) NSArray *sectionImages;
@property (nonatomic, strong) NSArray *sectionSelectedImages;
```

#####方法说明
