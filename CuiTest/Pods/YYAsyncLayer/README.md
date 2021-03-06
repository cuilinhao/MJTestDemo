YYAsyncLayer
==============

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/ibireme/YYAsyncLayer/master/LICENSE)&nbsp;
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/YYAsyncLayer.svg?style=flat)](http://cocoapods.org/?q=YYAsyncLayer)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/YYAsyncLayer.svg?style=flat)](http://cocoapods.org/?q=YYAsyncLayer)&nbsp;
[![Support](https://img.shields.io/badge/support-iOS%206%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;
[![Build Status](https://travis-ci.org/ibireme/YYAsyncLayer.svg?branch=master)](https://travis-ci.org/ibireme/YYAsyncLayer)

iOS utility classes for asynchronous rendering and display.<br/>
(It was used by [YYText](https://github.com/ibireme/YYText))


Simple Usage
==============

    @interface YYLabel : UIView
    @property NSString *text;
    @property UIFont *font;
    @end
	
    @implementation YYLabel

    - (void)setText:(NSString *)text {
        _text = text.copy;
        [[YYTransaction transactionWithTarget:self selector:@selector(contentsNeedUpdated)] commit];
    }
	
    - (void)setFont:(UIFont *)font {
        _font = font;
        [[YYTransaction transactionWithTarget:self selector:@selector(contentsNeedUpdated)] commit];
    }
    
    - (void)layoutSubviews {
        [super layoutSubviews];
        [[YYTransaction transactionWithTarget:self selector:@selector(contentsNeedUpdated)] commit];
    }

    - (void)contentsNeedUpdated {
        // do update
        [self.layer setNeedsDisplay];
    }
	
    #pragma mark - YYAsyncLayer

    + (Class)layerClass {
        return YYAsyncLayer.class;
    }

    - (YYAsyncLayerDisplayTask *)newAsyncDisplayTask {
        
        // capture current state to display task
        NSString *text = _text;
        UIFont *font = _font;
        
        YYAsyncLayerDisplayTask *task = [YYAsyncLayerDisplayTask new];
        task.willDisplay = ^(CALayer *layer) {
            //...
        };
        
        task.display = ^(CGContextRef context, CGSize size, BOOL(^isCancelled)(void)) {
            if (isCancelled()) return;
            NSArray *lines = CreateCTLines(text, font, size.width);
            if (isCancelled()) return;
            
            for (int i = 0; i < lines.count; i++) {
                CTLineRef line = line[i];
                CGContextSetTextPosition(context, 0, i * font.pointSize * 1.5);
                CTLineDraw(line, context);
                if (isCancelled()) return;
            }
        };
        
        task.didDisplay = ^(CALayer *layer, BOOL finished) {
            if (finished) {
                // finished
            } else {
                // cancelled
            }
        };
        
        return task;
    }
    @end


Installation
==============

### CocoaPods

1. Add `pod 'YYAsyncLayer'` to your Podfile.
2. Run `pod install` or `pod update`.
3. Import \<YYAsyncLayer/YYAsyncLayer.h\>.


### Carthage

1. Add `github "ibireme/YYAsyncLayer"` to your Cartfile.
2. Run `carthage update --platform ios` and add the framework to your project.
3. Import \<YYAsyncLayer/YYAsyncLayer.h\>.


### Manually

1. Download all the files in the YYAsyncLayer subdirectory.
2. Add the source files to your Xcode project.
3. Import `YYAsyncLayer.h`.


Documentation
==============
Full API documentation is available on [CocoaDocs](http://cocoadocs.org/docsets/YYAsyncLayer/).<br/>
You can also install documentation locally using [appledoc](https://github.com/tomaz/appledoc).


Requirements
==============
This library requires `iOS 6.0+` and `Xcode 7.0+`.


License
==============
YYAsyncLayer is provided under the MIT license. See LICENSE file for details.




<br/><br/>
---
????????????
==============
iOS ????????????????????????????????????<br/>
(??????????????? [YYText](https://github.com/ibireme/YYText) ???????????????????????????)


????????????
==============

    @interface YYLabel : UIView
    @property NSString *text;
    @property UIFont *font;
    @end
	
    @implementation YYLabel

    - (void)setText:(NSString *)text {
        _text = text.copy;
        [[YYTransaction transactionWithTarget:self selector:@selector(contentsNeedUpdated)] commit];
    }
	
    - (void)setFont:(UIFont *)font {
        _font = font;
        [[YYTransaction transactionWithTarget:self selector:@selector(contentsNeedUpdated)] commit];
    }
    
    - (void)layoutSubviews {
        [super layoutSubviews];
        [[YYTransaction transactionWithTarget:self selector:@selector(contentsNeedUpdated)] commit];
    }

    - (void)contentsNeedUpdated {
        // do update
        [self.layer setNeedsDisplay];
    }
	
    #pragma mark - YYAsyncLayer

    + (Class)layerClass {
        return YYAsyncLayer.class;
    }

    - (YYAsyncLayerDisplayTask *)newAsyncDisplayTask {
        
        // capture current state to display task
        NSString *text = _text;
        UIFont *font = _font;
        
        YYAsyncLayerDisplayTask *task = [YYAsyncLayerDisplayTask new];
        task.willDisplay = ^(CALayer *layer) {
            //...
        };
        
        task.display = ^(CGContextRef context, CGSize size, BOOL(^isCancelled)(void)) {
            if (isCancelled()) return;
            NSArray *lines = CreateCTLines(text, font, size.width);
            if (isCancelled()) return;
            
            for (int i = 0; i < lines.count; i++) {
                CTLineRef line = line[i];
                CGContextSetTextPosition(context, 0, i * font.pointSize * 1.5);
                CTLineDraw(line, context);
                if (isCancelled()) return;
            }
        };
        
        task.didDisplay = ^(CALayer *layer, BOOL finished) {
            if (finished) {
                // finished
            } else {
                // cancelled
            }
        };
        
        return task;
    }
    @end


??????
==============

### CocoaPods

1. ??? Podfile ????????? `pod 'YYAsyncLayer'`???
2. ?????? `pod install` ??? `pod update`???
3. ?????? \<YYAsyncLayer/YYAsyncLayer.h\>???


### Carthage

1. ??? Cartfile ????????? `github "ibireme/YYAsyncLayer"`???
2. ?????? `carthage update --platform ios` ??????????????? framework ????????????????????????
3. ?????? \<YYAsyncLayer/YYAsyncLayer.h\>???


### ????????????

1. ?????? YYAsyncLayer ??????????????????????????????
2. ??? YYAsyncLayer ?????????????????????(??????)??????????????????
3. ?????? `YYAsyncLayer.h`???


??????
==============
???????????? [CocoaDocs](http://cocoadocs.org/docsets/YYAsyncLayer/) ???????????? API ????????????????????? [appledoc](https://github.com/tomaz/appledoc) ?????????????????????


????????????
==============
????????????????????? `iOS 6.0` ??? `Xcode 7.0`???


?????????
==============
YYAsyncLayer ?????? MIT ????????????????????? LICENSE ?????????

????????????
==============
[iOS ???????????????????????????
](http://blog.ibireme.com/2015/11/12/smooth_user_interfaces_for_ios/) 

