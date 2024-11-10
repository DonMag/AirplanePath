//
//  PDFExtractor.h
//  AirplanePath
//
//  Created by Don Mag on 11/5/24.
//

#import <PDFKit/PDFKit.h>
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface PDFExtractor : NSObject
+ (NSArray<id> *)extractVectorPathsFromPDF:(NSURL *)pdfURL;
+ (NSImage *)imageFromPDFPage:(NSURL *)pdfURL pageNum:(NSInteger)pageNum targetSize:(CGSize)targetSize rotationRadians:(CGFloat)radians withColor:(NSColor *)withColor;
@end

NS_ASSUME_NONNULL_END
