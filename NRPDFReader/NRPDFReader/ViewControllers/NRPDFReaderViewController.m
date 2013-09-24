//
//  NRPDFReaderViewController.m
//  NRPDFReader
//
//  Created by Naveen R on 10/09/13.
//

#import "NRPDFReaderViewController.h"
#import "PDFPageRenderer.h"
#import "NRThumbnailCell.h"
#import "NRPDFPageDetails.h"

#define klandscapewidthforthubnailtableview 162.0f
#define kheightforthubnailtableviewCell 118.0f

#define klandscapewidthforIpad 1024.0f
#define klandscapeHeightforIpad 748.0f
#define kportraitHeightforIpad 1004.0f
#define kportraitWidthforIpad 768.0f
#define kCloseButtonY 18.0f

#define kInitialBorderBetweenPages 10.0f    // This value you have to calculate manually after loading the PDF with UIWebView.
                                            // I used "Free ruler" application to calculate the gap in initial state


@interface NRPDFReaderViewController ()

@property (nonatomic,strong) NSMutableArray* thumbnailImages;
@property (nonatomic,strong) NSMutableArray* pageDetailsArray;
@property (nonatomic,strong) UIScrollView* webScrollView;
@property (nonatomic,assign) NSInteger       selectedRowIndex;
@property (nonatomic,assign) NSInteger       deselectedRowIndex;


@end

@implementation NRPDFReaderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithPDFDocument: (NRPDFDocument *)inPDFDocument
{
    self = [super initWithNibName:@"NRPDFReaderViewController" bundle:nil];
    
    if(self)
    {
        self.document = inPDFDocument;
        _thumbnailImages = [[NSMutableArray alloc] init];
        _pageDetailsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedRowIndex = 0;
    self.deselectedRowIndex = -1;
    
    [self setFramesForSubViews];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), ^(void)
                   {
                       [self getThumbnailsWithCompletionBlock : ^(void)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^(void)
                            {
                                [self.thumbnailTable reloadData];
                            });
                        }];
                   });

    
    [self loadPDF];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Make PDFReaderViewController the observer for the frame property of UIWebScrollView
    // Create an Array which contains Y value of all its pages
    
    self.webScrollView = [self.webView scrollView];
    [self.webScrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
    [self loadPageDetailsArray];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.webScrollView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load PDF

- (void)loadPDF
{
    self.webView.scalesPageToFit = YES;
    self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.webView.scrollView.delegate = self;

    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:self.document.fileURL];
    [self.webView loadRequest:urlRequest];
}

#pragma mark - Action Methods

- (IBAction)closeButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

#pragma mark - TableView Delegate & Datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.thumbnailImages count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kheightforthubnailtableviewCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* reuseIdentifier = @"thumbnailCell";
    NRThumbnailCell* cell;
    
    cell = [self.thumbnailTable dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(cell == nil)
    {
        cell = [[NRThumbnailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.thumbnailImageView setImage:[self.thumbnailImages objectAtIndex:indexPath.row]];
    
    if(self.selectedRowIndex == indexPath.row)
    {
        UIImageView* borderImageView = cell.thumbnailBorderImageView;
        CGAffineTransform borderImageInitialTransform = cell.thumbnailBorderImageView.transform;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2f];
        borderImageView.transform = CGAffineTransformScale(borderImageInitialTransform, 1.3, 1.3);
        [UIView commitAnimations];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2f];
        borderImageView.transform = borderImageInitialTransform;
        [UIView commitAnimations];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selectedIndex is %d", self.selectedRowIndex);
    NSLog(@"DeselectedIndex is %d", self.deselectedRowIndex);

        if(indexPath.row == self.selectedRowIndex)
        {
            NRThumbnailCell *thumbnailCell = (NRThumbnailCell *)cell;
            
            UIImageView* borderImageView = thumbnailCell.thumbnailBorderImageView;
            [borderImageView setHidden:NO];
        }
        else
        {
            NRThumbnailCell *thumbnailCell = (NRThumbnailCell *)cell;
            [thumbnailCell.thumbnailBorderImageView setHidden:YES];
        }
}


- (void)tableView:(UITableView* )tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSInteger rowIndex = indexPath.row;
        CGFloat offset = [[self.pageDetailsArray objectAtIndex:rowIndex] currentOffset];
        [self.webScrollView setContentOffset:CGPointMake(0, offset)animated:YES];
        
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
        NRThumbnailCell* cell = (NRThumbnailCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell.thumbnailBorderImageView setHidden:YES];
}

#pragma mark - ScrollView Delegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView      // called when scroll the webView with finger
{
    if(scrollView == self.webScrollView)
    {
        CGPoint the_offset = self.webScrollView.contentOffset;
        NSInteger visiblePageNumber;
        
        for(int i=0; i<self.pageDetailsArray.count; i++)
        {
            NRPDFPageDetails* the_PageDetails = [self.pageDetailsArray objectAtIndex:i];
            if(
               (the_offset.y >= (the_PageDetails.currentOffset - (the_PageDetails.currentHeight/2.0)))
               &&
               (the_offset.y <= (the_PageDetails.currentOffset + (the_PageDetails.currentHeight/2.0)))
               )
            {
                visiblePageNumber = i;
                break;
            }
        }
                
        if(visiblePageNumber != self.selectedRowIndex)
        {
            self.deselectedRowIndex = self.selectedRowIndex;
            self.selectedRowIndex = visiblePageNumber;
            
            // Make Indexpaths for both selected and deselected Rows
            
            NSIndexPath* indexPathForSelectedRow = [NSIndexPath indexPathForRow:self.selectedRowIndex inSection:0];
            NSIndexPath* indexPathForDeSelectedRow = [NSIndexPath indexPathForRow:self.deselectedRowIndex inSection:0];
            
            if([self.thumbnailTable isHidden] == NO)
            {
                [self.thumbnailTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathForDeSelectedRow,indexPathForSelectedRow, nil] withRowAnimation:UITableViewRowAnimationNone];
                
                if(![self.thumbnailTable.visibleCells containsObject:[self.thumbnailTable  cellForRowAtIndexPath:indexPathForSelectedRow]])
                    [self.thumbnailTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:visiblePageNumber inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            
        }
        
    }
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView   // called when webview scrolled because of selection in thumbnailTable
{
    if(scrollView == self.webScrollView)
    {
        CGPoint the_offset = self.webScrollView.contentOffset;
        NSInteger visiblePageNumber;
        
        for(int i=0; i<self.pageDetailsArray.count; i++)
        {
            NRPDFPageDetails* the_PageDetails = [self.pageDetailsArray objectAtIndex:i];
            if(
               (the_offset.y >= (the_PageDetails.currentOffset - (the_PageDetails.currentHeight/2.0)))
               &&
               (the_offset.y <= (the_PageDetails.currentOffset + (the_PageDetails.currentHeight/2.0)))
               )
            {
                visiblePageNumber = i;
                break;
            }
        }
                
        if(visiblePageNumber != self.selectedRowIndex)
        {
            self.deselectedRowIndex = self.selectedRowIndex;
            self.selectedRowIndex = visiblePageNumber;
            
            // Make Indexpaths for both selected and deselected Rows
            
            NSIndexPath* indexPathForSelectedRow = [NSIndexPath indexPathForRow:self.selectedRowIndex inSection:0];
            NSIndexPath* indexPathForDeSelectedRow = [NSIndexPath indexPathForRow:self.deselectedRowIndex inSection:0];
            
            if([self.thumbnailTable isHidden] == NO)
            {
                [self.thumbnailTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathForDeSelectedRow,indexPathForSelectedRow, nil] withRowAnimation:UITableViewRowAnimationNone];
                
                if(![self.thumbnailTable.visibleCells containsObject:[self.thumbnailTable  cellForRowAtIndexPath:indexPathForSelectedRow]])
                    [self.thumbnailTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:visiblePageNumber inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            
        }
        
    }
}


#pragma mark - Setting Frame

- (void)setFramesForSubViews
{
    if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
       self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        [self.thumbnailTable setHidden:NO];
        self.thumbnailTable.frame = CGRectMake(0, 0, klandscapewidthforthubnailtableview, klandscapeHeightforIpad);
        self.webView.frame = CGRectMake(klandscapewidthforthubnailtableview, 0, klandscapewidthforIpad - klandscapewidthforthubnailtableview, klandscapeHeightforIpad);
        CGFloat closebuttonOrigin  = (klandscapewidthforIpad - 20.0f - self.closeButton.frame.size.width);
        self.closeButton.frame = CGRectMake(closebuttonOrigin, kCloseButtonY, self.closeButton.frame.size.width, self.closeButton.frame.size.height);
    }
    else if(self.interfaceOrientation == UIInterfaceOrientationPortrait ||
            self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        [self.thumbnailTable setHidden:YES];
        self.webView.frame = CGRectMake(0, 0, kportraitWidthforIpad, kportraitHeightforIpad);
        CGFloat closebuttonOrigin  = (kportraitWidthforIpad - 20.0f - self.closeButton.frame.size.width);
        self.closeButton.frame = CGRectMake(closebuttonOrigin, kCloseButtonY, self.closeButton.frame.size.width, self.closeButton.frame.size.height);
        
    }
}

#pragma mark - DidRotateInterface

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self setFramesForSubViews];
}

#pragma mark - Making thumbnail images from PDFPages

/**
 @method        getThumbnailsWithCompletionBlock:
 @discussion    As soon as we load the vie, we generate small thumbnail image for each of the page in PDFDocument and add it to the datasource
                array for the thumbnail tableView
 */

- (void)getThumbnailsWithCompletionBlock : (CompletionBlock)inCompletionBlock
{
    for(NSInteger i=0; i < self.document.pageCount; i++)
    {
            [self getThumbnailForPage:(i+1) withImageBlock:^(UIImage* pageImage)
             {
                 if(pageImage)
                 {
                     [self.thumbnailImages addObject:pageImage];
                 }
             }];
    }
    inCompletionBlock();
}

/**
 @method        getThumbnailForPage: withImageBlock:
 @discussion    This method is used to get the UIImage extracted from a given page in PDF Document
 */

- (void)getThumbnailForPage:(NSInteger)inPageNo withImageBlock:(ImageBlock)inImageBlock
{
    CGPDFPageRef pageRef = CGPDFDocumentGetPage(self.document.pdfDocument, inPageNo);
    
    CGRect cropBox = CGPDFPageGetBoxRect(pageRef, kCGPDFCropBox);
	int pageRotation = CGPDFPageGetRotationAngle(pageRef);
	
	CGSize pageVisibleSize = CGSizeMake(cropBox.size.width, cropBox.size.height);
	if ((pageRotation == 90) || (pageRotation == 270) ||(pageRotation == -90)) {
		pageVisibleSize = CGSizeMake(cropBox.size.height, cropBox.size.width);
	}
    
    UIGraphicsBeginImageContext(pageVisibleSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [PDFPageRenderer renderPage:pageRef inContext:context];
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    inImageBlock(finalImage);
}

#pragma mark - Creating Page Details Array

/**
 @method        loadPageDetailsArray
 @discussion    This method will be called after the view gets loaded and corresponding to each page in PDF Document, an object of
                NRPDFPageDetails is created and added to the "pageDetailsArray" array.
                The NRPDFPageDetails contains all details of the page like, currentOffset, original Height, currentHeight
 */

- (void)loadPageDetailsArray
{
    for(int i=0; i<self.document.pageCount; i++)
    {
        CGPDFDocumentRef pdfDocument = self.document.pdfDocument;
        CGPDFPageRef page = CGPDFDocumentGetPage(pdfDocument, i+1);
        CGFloat rotation = CGPDFPageGetRotationAngle(page);
        CGRect originalSize = CGPDFPageGetBoxRect(page, kCGPDFCropBox);
        CGFloat scalingToOriginalPage;
        NRPDFPageDetails* the_PdfPageDetails = [[NRPDFPageDetails alloc] init];
        the_PdfPageDetails.pageNumber = i+1;
        
        if ((rotation == 90) || (rotation == 270) ||(rotation == -90))
        {
            the_PdfPageDetails.originalWidth = originalSize.size.height;
            the_PdfPageDetails.originalHeight = originalSize.size.width;
        }
        else
        {
            the_PdfPageDetails.originalWidth = originalSize.size.width;
            the_PdfPageDetails.originalHeight = originalSize.size.height;
        }
        scalingToOriginalPage = ((self.webScrollView.contentSize.width - (2*kInitialBorderBetweenPages))/the_PdfPageDetails.originalWidth);
        the_PdfPageDetails.currentHeight = the_PdfPageDetails.originalHeight*scalingToOriginalPage;
        
        [self.pageDetailsArray addObject:the_PdfPageDetails];
    }
    [self updatePageOffsets];
    
    NSLog(@"Test");
}

/**
 @method        observeValueForKeyPath: ofObject: change: context
 @discussion    Whenever the contentSize of the webView's scrollView changes, this method gets called.
                So this method will be called whenever we zoom the pdf Document
 */


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGFloat scalingToOriginalPage;
    NSInteger i;
    if([keyPath isEqualToString:@"contentSize"] && object == self.webScrollView)
    {
        CGFloat originalHeightOfPage;
        CGFloat originalWidthOfPage;
        for(i=0; i< [self.pageDetailsArray count]; i++)
        {
            originalHeightOfPage  = [[self.pageDetailsArray objectAtIndex:i] originalHeight];
            originalWidthOfPage = [[self.pageDetailsArray objectAtIndex:i] originalWidth];
            scalingToOriginalPage = ((self.webScrollView.contentSize.width - 2*kInitialBorderBetweenPages)/originalWidthOfPage);
            [[self.pageDetailsArray objectAtIndex:i] setCurrentHeight:scalingToOriginalPage*originalHeightOfPage];
        }
        
        
        [self updatePageOffsets];
        NSLog(@"New content size is %@",NSStringFromCGSize(self.webScrollView.contentSize));
    }
}

/**
 @method        updatePageOffsets
 @discussion    Whenever the contentsize of the WebView's scrollView is changed, we update the currentOffset property of the NRPDFPageDetails object
                corresponding to that particular page. So when you click on any cell in the thumbnail table, WebView's scrollView is scrolled to the
                currentOffset
 */

- (void)updatePageOffsets
{
    for(int i=0; i<self.pageDetailsArray.count; i++)
    {
        CGFloat the_offset = 0;
        NRPDFPageDetails* the_pageDetails = [self.pageDetailsArray objectAtIndex:i];
        for(int j=i; j>=0; j--)
        {
            if(j != 0)
            {
                the_offset += [[self.pageDetailsArray objectAtIndex:(j-1)] currentHeight];
                the_offset += kInitialBorderBetweenPages;
            }
            else
            {
                the_offset += 0.0f;
            }
        }
        the_pageDetails.currentOffset = the_offset;
        NSLog(@"Offset for page no %d is %f", i+1,[[self.pageDetailsArray objectAtIndex:i] currentOffset]);
    }
    
}

@end
