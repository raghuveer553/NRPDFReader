//
//  NRPDFDocument.h
//  NRPDFReader
//
//  Created by Naveen R on 16/09/13.
//

#import <Foundation/Foundation.h>

@interface NRPDFDocument : NSObject

@property (nonatomic,assign) CGPDFDocumentRef pdfDocument;
@property (nonatomic,strong) NSString* fileName;
@property (nonatomic,assign) NSInteger pageCount;
@property (nonatomic,strong) NSURL* fileURL;

- (id)initWithFilePath : (NSString *)inFilePath;

@end
