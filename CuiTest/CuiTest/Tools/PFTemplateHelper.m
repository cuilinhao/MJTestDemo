//
//  PFTemplateHelper.m
//  CuiTest
//
//  Created by 崔林豪 on 2021/5/16.
//

#import "PFTemplateHelper.h"

#import <libkern/OSAtomic.h>
#import "YYText.h"

@implementation PFTemplateHelper


NSString *_whiteSpace() {
	unichar placeChar = 0xFFFC;
	return [NSString stringWithCharacters:&placeChar length:1];
}

NSAttributedString *_attachmentAttributeString(UIImage *image,CGFloat lineSpace) {
	if (!image) {
		return [NSAttributedString new];
	}
	NSTextAttachment *attacment = [[NSTextAttachment alloc] init];
	attacment.image = image;
	attacment.bounds = CGRectMake(newCountWidth(12),lineSpace, image.size.width,image.size.height);
	return [NSAttributedString attributedStringWithAttachment:attacment];
}


NSAttributedString *_ellispsesCharacterAttributeString(CTLineRef lastLine) {
	CFArrayRef runArr = CTLineGetGlyphRuns(lastLine);
	if (!runArr) nil;
	CTRunRef lastRun = CFArrayGetValueAtIndex(runArr, CFArrayGetCount(runArr) - 1);
	if (!lastRun) return nil;
	NSDictionary *attbutes = (__bridge NSDictionary *)CTRunGetAttributes(lastRun);
	if (!attbutes) return nil;
	NSString *kEllipsesCharacter = @"\u2026";
	return  [[NSAttributedString alloc] initWithString:kEllipsesCharacter attributes:attbutes];
}

NSAttributedString *_cutLineAttributeString(NSMutableAttributedString *lastLineAttributeString, NSAttributedString *truncationString, CGFloat width) {
	if (!truncationString) {
		return lastLineAttributeString;
	}
	CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)lastLineAttributeString);
	CGFloat lineWidth = CTLineGetTypographicBounds(line, NULL, NULL, NULL);
	CFRelease(line);
	if (lineWidth > width) {
		NSString *str = lastLineAttributeString.string;
		NSRange r = [str rangeOfComposedCharacterSequencesForRange:NSMakeRange(str.length - truncationString.string.length - 1, 1)];
		[lastLineAttributeString deleteCharactersInRange:r];
		return _cutLineAttributeString(lastLineAttributeString, truncationString, width);
	}
	return lastLineAttributeString;
	
}


+ (NSMutableAttributedString *)pf_addLabelWithBehindText:(id)textword image:(UIImage *)image limitLinesNum:(NSUInteger)lineNum attDic:(NSDictionary *)attDic limitWidth:(CGFloat)limitWidth lineSpace:(CGFloat)lineSpace
{
	NSTimeInterval begin = CACurrentMediaTime();
	CTFramesetterRef framesetter    = NULL;
	CGMutablePathRef framePath      = NULL;
	CTFrameRef frame                = NULL;
	CFArrayRef lines                = NULL;
	CTLineRef lastLine              = NULL;
	CGFloat lastLineWidth           = 0.f;
	CGFloat ascent,descent,leading;
	
	NSInteger maxNumbers            = lineNum;
	NSInteger totalLineNumbers      = 0;
	NSInteger currentNumbers        = 0;
	NSAttributedString *textAttachmentAtt = nil;

	NSMutableAttributedString *maintitleAttribute = [NSMutableAttributedString new];
	NSString *texttext = @"";
	if ([textword isKindOfClass:[NSString class]]) {
		texttext = (NSString *)textword;
		texttext = texttext.length ? texttext : _whiteSpace();
		texttext = [texttext stringByAppendingString:@" "];
		maintitleAttribute = [[NSMutableAttributedString alloc] initWithString:texttext attributes:attDic];
	} else if ([textword isKindOfClass:[NSAttributedString class]]) {
		NSAttributedString *a = (NSAttributedString *)textword;
		maintitleAttribute = [[NSMutableAttributedString alloc] initWithAttributedString:a];
		[maintitleAttribute addAttributes:attDic range:NSMakeRange(0, maintitleAttribute.length)];

	}
	CGFloat titleWidth          = limitWidth;
	
	
	framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)maintitleAttribute);
	if (!framesetter)  goto localFail;
	framePath = CGPathCreateMutable();
	if (!framePath) goto localFail;
	CGPathAddRect(framePath, NULL, CGRectMake(0, 0, titleWidth, CGFLOAT_MAX));
	frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [maintitleAttribute length]), framePath, NULL);
	if (!frame) goto localFail;
	lines = CTFrameGetLines(frame);
	if (!lines) goto localFail;
	
	totalLineNumbers = CFArrayGetCount(lines);
	currentNumbers = MIN(maxNumbers, totalLineNumbers);
	lastLine = CFArrayGetValueAtIndex(lines, currentNumbers - 1);
	
	lastLineWidth = (CGFloat)CTLineGetTypographicBounds(lastLine, &ascent, &descent, &leading);
	textAttachmentAtt = _attachmentAttributeString(image,lineSpace);
	
	if (currentNumbers > maxNumbers - 1) {
		
		CFRange lastLineRnge = CTLineGetStringRange(lastLine);
		NSMutableAttributedString *lastLineAtt = [[maintitleAttribute attributedSubstringFromRange:NSMakeRange(lastLineRnge.location, lastLineRnge.length)] mutableCopy];
		NSMutableAttributedString *beforLastLineAttbuteString = [[maintitleAttribute attributedSubstringFromRange:NSMakeRange(0, lastLineRnge.location)] mutableCopy];
		NSMutableAttributedString *resultAttributeString = beforLastLineAttbuteString;
		
		// 如果没有image 给出需要添加“...”的距离
		NSAttributedString *ellipsesCharacterAttStr = _ellispsesCharacterAttributeString(lastLine);
		CGFloat w = 0.f;
		if (image) {
			w = image.size.width;
		} else {
			w = ellipsesCharacterAttStr.size.width;
		}

		BOOL isAddEllipsesCharacter = titleWidth - lastLineWidth < w;
		if (!isAddEllipsesCharacter && maxNumbers >= totalLineNumbers) {// && 文字行数超过限制展示行数 添加...
			/// 不需要加省略号
			[resultAttributeString appendAttributedString:lastLineAtt];
			if (textAttachmentAtt) {
				[resultAttributeString appendAttributedString:textAttachmentAtt];
			}
		} else {
			if (ellipsesCharacterAttStr) {
				[lastLineAtt appendAttributedString:ellipsesCharacterAttStr];
			}
			NSAttributedString *cutLineAttbuteString = _cutLineAttributeString(lastLineAtt, ellipsesCharacterAttStr, titleWidth - image.size.width);
			[resultAttributeString appendAttributedString:cutLineAttbuteString];
			if (textAttachmentAtt) {
				[resultAttributeString appendAttributedString:textAttachmentAtt];
			}
		}
		if (framesetter) CFRelease(framesetter);
		if (framePath) CFRelease(framePath);
		if (frame) CFRelease(frame);
		NSTimeInterval end = CACurrentMediaTime();
		NSLog(@"\n耗时：%f\n",end - begin);
		return resultAttributeString;
	}
	if (textAttachmentAtt) {
		[maintitleAttribute appendAttributedString:textAttachmentAtt];
	}
	
localFail: {
	if (framesetter) CFRelease(framesetter);
	if (framePath) CFRelease(framePath);
	if (frame) CFRelease(frame);
	if (!textAttachmentAtt) {
		NSAttributedString *overTimerLabelAtt = _attachmentAttributeString(image,limitWidth);
		[maintitleAttribute appendAttributedString:overTimerLabelAtt];
	}
}
	return maintitleAttribute;
	
}


@end
