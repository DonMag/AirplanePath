//
//  UtilityMethods.h
//  AirplanePath
//
//  Created by Don Mag on 11/13/24.
//

#import <Cocoa/Cocoa.h>
#import <PDFKit/PDFKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UtilityMethods : NSObject

+ (CGRect)scaleRect:(CGRect)sourceRect toFit:(CGRect)targetRect;
+ (CGRect)boundsForRect:(CGRect)origR withRotation:(CGFloat)angleInRadians;

+ (NSArray<id> *)extractVectorPathsFromPDF:(NSURL *)pdfURL;
+ (NSImage *)imageFromPDFPage:(NSURL *)pdfURL pageNum:(NSInteger)pageNum targetSize:(CGSize)targetSize rotationRadians:(CGFloat)radians withColor:(NSColor *)withColor;

@end

NS_ASSUME_NONNULL_END
