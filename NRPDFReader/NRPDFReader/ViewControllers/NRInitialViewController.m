//
//  NRInitialViewController.m
//  NRPDFReader
//
//  Created by Naveen R on 10/09/13.
//  Copyright (c) 2013 Sourcebits. All rights reserved.
//

#import "NRInitialViewController.h"
#import "NRPDFReaderViewController.h"

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonAction:(id)sender
{
    NRPDFReaderViewController* pdfReaderViewController = [[NRPDFReaderViewController alloc] initWithNibName:@"NRPDFReaderViewController" bundle:nil];
    [self presentViewController:pdfReaderViewController animated:YES completion:^(void){}];
}
@end
