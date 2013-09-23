//
//  NRPDFPageDetails.h
//  NRPDFReader
//
//  Created by Naveen R on 19/09/13.
//

#import <Foundation/Foundation.h>

@interface NRPDFPageDetails : NSObject

@property (nonatomic,assign) NSInteger pageNumber;
@property (nonatomic,assign) CGFloat originalWidth;
@property (nonatomic,assign) CGFloat originalHeight;
@property (nonatomic,assign) CGFloat currentHeight;
@property (nonatomic,assign) CGFloat currentOffset;

@end
