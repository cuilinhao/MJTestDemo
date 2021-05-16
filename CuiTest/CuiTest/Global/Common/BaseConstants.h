//
//  BaseConstants.h
//  CuiTest
//
//  Created by 崔林豪 on 2021/5/16.
//

#ifndef BaseConstants_h
#define BaseConstants_h


#pragma mark - print & version
#ifdef DEBUG //
#define NSLog(...) NSLog(__VA_ARGS__)
#define PFLog( s, ... ) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(s), ##__VA_ARGS__] UTF8String] );

#else // 发布状态, 关闭LOG功能
#define NSLog(...)
#define PFLog(...)
#endif

// 当前系统版本
#define DSystemVersion          ([[[UIDevice currentDevice] systemVersion] doubleValue])

// 当前软件版本
#define DAPPVersion          ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])

#pragma mark - size
// 屏幕宽
#define SCREEN_WIDTH       [[UIScreen mainScreen] bounds].size.width
// 屏幕高
#define SCREEN_HEIGHT      [[UIScreen mainScreen] bounds].size.height

// View 坐标(x,y)和宽高(width,height)
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height

// 系统控件默认高度
#define StatusBarHeight        (isiPhoneX?44.f:20.f)
// 导航栏 高度
#define TopBarHeight          (isPad?(70.f) :(isiPhoneX?88.f:64.f))
#define BottomBarHeight        (isiPhoneX?83.f:49.f)
#define TabBarHeight           (isiPhoneX?83.f:49.f)


/// 顶部安全距离
#define kTopSafeArea(height)      (isiPhoneX ? 44.f : 20.f) + height
/// 底部安全距离
#define kBtmSafeArea(height)      (isiPhoneX ? 34.f : 0.f) + height


// 滑动导航高度
#define kHeightOfTopScrollView 44.0f
// ios 6， ios 7 状态栏偏移
#define  FromStatusBarHeight   (isiPhoneX?44.f:20.f)

#define  FromWorkBarHeight   (isiPhoneX?54.f:30.f)

// 底部 红蓝条 高度
#define MARKVIEW_HEIGHT (isiPhoneX?27.f:0.f)

#pragma mark - image
// 图片bundle
#define IMAGEBUNDLENAME  @"DisplayAnimationImage.bundle"

// 加载图片
#define PNGIMAGE(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]
#define JPGIMAGE(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]]
#define IMAGE(NAME, EXT)        [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]]
#define IMAGENAMED(NAME)        [UIImage imageNamed:NAME]
#define DEFAULT_IMG             [UIImage yy_imageWithColor:kHexColor(@"#e6ecf6")]

/// 默认占位背景图
#define kDefaultPlaceholderImage [CompputeTools pf_placeholderImage]

#pragma mark - color
// 颜色(RGB)
#define kRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define kRGBColor(r, g, b) kRGBAColor(r, g, b, 1)
// 随机颜色
#define kRandomColor kRGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))
// 十六进制颜色
#define kHexColor(hexColorStr) [UIColor colorFromHexString:hexColorStr]

// RGB颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#pragma mark - font
// 字体大小
#define kFont(size) [UIFont systemFontOfSize:size]
#define kMediumFont(size) [UIFont systemFontOfSize:(size) weight:UIFontWeightMedium]
#define kBoldFont(size) [UIFont boldSystemFontOfSize:size]
#define kNameFont(name, size) [UIFont fontWithName:(name) size:(size)]

#pragma mark - iPhone Screen
// 是否Retina屏
#define PF_isRetina                ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(640, 960), \
[[UIScreen mainScreen] currentMode].size) : \
NO)

// 是否iPhone5
#define isiPhone5               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(640, 1136), \
[[UIScreen mainScreen] currentMode].size) : \
NO)

// 是否iPhone6 的尺寸
#define isiPhone6Size               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(750, 1334), \
[[UIScreen mainScreen] currentMode].size) : \
NO)

// 是否是 iphone6p 的尺寸
#define isiPhone6pSize               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(1242, 2208), \
[[UIScreen mainScreen] currentMode].size) : \
NO)

#define isiPhoneX   [PFCommonUtil isIphoneX] // 是否iPhone
#define isPad           (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) // 是否iPad

#pragma mark - other
// 弱引用
#define WEAK_SELF __weak typeof(self) weakSelf = self
#define STRONG_SELF __strong typeof(self) strongSelf = weakSelf

// 单例
#define kUserDefaults [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

#define kPFMsgTimeCacheName @"pf_MessageCreateTimeCache"

#ifndef MessageUnRead
#define MessageUnRead @"messageUnRead"
#endif

// UIView - viewWithTag
#define VIEWWITHTAG(_OBJECT, _TAG)\
\
[_OBJECT viewWithTag : _TAG]

//GCD
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

#pragma mark - iPhone 布局适配
//基于iPhoneX和iPhone6p计算适配高度(列表高度和图片宽高)
#define CountHeightBaseX(height) ((isiPhone6pSize || isiPhoneX) ? \
(height/3) : \
(height*SCREEN_WIDTH/1125))

// 以二倍iPhone效果图适配
#define CountWidth(width) (SCREEN_WIDTH*(width)/750)
#define CountHeight(width,height)  (height*SCREEN_WIDTH/750)//((SCREEN_WIDTH*(width)/750)*(height)/(width))
#define kCountHeight(height) (height*SCREEN_WIDTH/750)

// 以三倍iPhone效果图适配
#define newCountWidth(width) (SCREEN_WIDTH*(width)/1125)
#define newCountHeight(height) (SCREEN_HEIGHT*(height)/2436)

#pragma mark - iPad & iPhone 同时适配
/**
											基于1125px（3倍率） |    换算过程      |     ipad端1536px（2倍率）  |    是否换算成功
 状态栏（高）                    |      132                        |          /             |                  40                        |     固定尺寸
 导航栏（高）                    |       132                       |         /              |                  100                      |        特殊
					+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 导航栏（返回icon）          |       30*56                   |+                        +|                   20*38              |        是
 导航栏（title）                  |       55                        |+                        +|                    37                   |        是
 字段文字                           |       48                        |+                        +|                     32                  |        是
 字段行高                           |       207                      |+  手机尺寸/1.5  +|                     138                |        是
 验证码icon                        |       330*102              |+                         +|                   220*68             |        是
 备注小字                           |       39                       |+                         +|                     26                   |        是
 下一步按钮                       |          997*150           |+                         +|                      1439*100       |        是
 页面边距                           |       75                       |+                         +|                       50                 |         是
				   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 淘宝搜索栏                      |          105                    |+  手机尺寸/1.5   +|                     70                  |           是
 中间楼层内容                  |          /                          |  手机尺寸直接同  |                       /                   |          特殊
				   |                                    |   比放大到IPAD    |                                            |
 淘宝标签栏                      |           150                   |+  手机尺寸/1.5   +|                     100                |            是
 
 */

// 根据三倍iPhone效果图 适配 二倍iPad
#define iPad_CountWidth(width) (SCREEN_WIDTH*((width)/2.0*3/1.5)/1536) //使用CountWidth
#define iPad_NewCountWidth(width) (SCREEN_WIDTH*((width)/1.5)/1536) //使用newCountWidth
#define iPad_NewCountHeight(height) (SCREEN_HEIGHT*((height)/1.5)/2048) //使用newCountHeight
#define iPad_CountHeightBaseX(height) ((height)/3.0*1.365) //使用CountHeightBaseX 且用于非字段页

/* 同时适配iPad和iPhone */
//使用CountWidth、kCountHeight
#define pf_CountWidth(width) (isPad ? iPad_CountWidth(width) : CountWidth(width))
//使用CountHeight(注：CountHeight = CountWidth = kCountHeight)
#define pf_CountHeight(width,height) pf_CountWidth(height)
//使用newCountWidth
#define pf_NewCountWidth(width) (isPad ? iPad_NewCountWidth(width) : newCountWidth(width))
//使用newCountHeight
#define pf_NewCountHeight(height) (isPad ? iPad_NewCountHeight(height) : newCountHeight(height))

//CountHeightBaseX：非字段页（P系列和X系列所有元素大小高度一致的）美工要求基于iPhoneX的大小 w*1.365
#define pf_CountHeightBaseX(height) (isPad ? iPad_CountHeightBaseX(height) : CountHeightBaseX(height))
//CountHeightBaseX：字段页（纯列表页）不要等比放大，要是原来尺寸/1.5
#define pf_ZoomCountHeightBaseX(height) (isPad ? pf_NewCountWidth(height) : CountHeightBaseX(height))

//控件宽度适配：固定的宽度时使用此替换(当固定的宽度 ≈ 字体长度时)
#define pf_width_layout(width) (isPad ? (width)*1.5 : (width))
//ipad要求左右页面边距是75  但是原手机是newCountWidth(45)  注意：使用的时候看下原代码是不是45
#define pf_SpaceWidth (isPad ? pf_NewCountWidth(75) : newCountWidth(45))

//等比放大
#define pf_scale_ratio 1.365

#define  kBigSpace      (NSInteger)pf_CountWidth(50)
#define  kSmallSpace    (NSInteger)pf_CountWidth(20)
#define  kCellHeight    (NSInteger)pf_CountWidth(90)



#endif /* BaseConstants_h */
