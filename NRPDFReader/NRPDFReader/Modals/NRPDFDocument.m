//
//  NRPDFDocument.m
//  NRPDFReader
//
//  Created by Naveen R on 16/09/13.
//

#import "NRPDFDocument.h"

@implementation NRPDFDocument

- (id)initWithFilePath : (NSString *)inFilePath
{
    self = [super init];
    if(self)
    {
        // Take the filepath and make a pdf document out of it
        const char *cStringOfFilePath = [inFilePath cStringUsingEncoding:NSASCIIStringEncoding];
        CFStringRef path;
        CFURLRef url;
        
        path = CFStringCreateWithCString(NULL, cStringOfFilePath, kCFStringEncodingUTF8);
        url = CFURLCreateWithFileSystemPath(NULL,
                                            path,
                                            kCFURLPOSIXPathStyle,
                                            0);
        CFRelease(path);
        
        // alloc and init properties
        
        
        self.pdfDocument = CGPDFDocumentCreateWithURL (url);
        CFRelease(url);
        if(self.pdfDocument)
        {
            self.pageCount   = CGPDFDocumentGetNumberOfPages(self.pdfDocument);
        }
        NSLog(@"The no of pages are  : %d",self.pageCount);
        self.fileName    = [inFilePath lastPathComponent];
        self.fileURL     = [[NSURL alloc] initFileURLWithPath:inFilePath];

    }
    return self;
}

@end
