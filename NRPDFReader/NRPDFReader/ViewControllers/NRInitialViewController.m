//
//  NRInitialViewController.m
//  NRPDFReader
//
//  Created by Naveen R on 10/09/13.
//

#import "NRInitialViewController.h"
#import "NRPDFReaderViewController.h"
#import "NRPDFDocument.h"

@interface NRInitialViewController ()

@end

@implementation NRInitialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonAction:(id)sender
{
    // Create a NRPDFDocument's object and create NRPDFReaderViewController's object using it
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"UISwitch" ofType:@"pdf"];;
    NRPDFDocument* pdfDocument = [[NRPDFDocument alloc] initWithFilePath:filePath];
    
    NRPDFReaderViewController* pdfReaderViewController = [[NRPDFReaderViewController alloc] initWithPDFDocument:pdfDocument];
    [self presentViewController:pdfReaderViewController animated:YES completion:^(void){}];
}
@end
