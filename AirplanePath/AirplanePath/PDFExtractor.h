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
+ (NSArray<NSBezierPath *> *)bezextractVectorPathsFromPDF:(NSURL *)pdfURL;
+ (NSArray<id> *)extractVectorPathsFromPDF:(NSURL *)pdfURL;

@end

NS_ASSUME_NONNULL_END
