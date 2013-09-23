//
//  NRPDFReaderViewController.h
//  NRPDFReader
//
//  Created by Naveen R on 10/09/13.
//

#import <UIKit/UIKit.h>
#import "NRPDFDocument.h"

typedef void (^CompletionBlock)(void);
typedef void (^ImageBlock)(UIImage*);


@interface NRPDFReaderViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *thumbnailTable;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

/**
 @property    document
 @discussion  NRPDFDocument is the modal object of this viewController. This object contains the pdfDocument in it.
 */

@property (nonatomic,strong) NRPDFDocument* document;

- (id) initWithPDFDocument: (NRPDFDocument *)inPDFDocument;
- (IBAction)closeButtonAction:(id)sender;

@end
