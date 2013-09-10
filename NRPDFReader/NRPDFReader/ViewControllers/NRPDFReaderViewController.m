//
//  NRPDFReaderViewController.m
//  NRPDFReader
//
//  Created by Naveen R on 10/09/13.
//  Copyright (c) 2013 Sourcebits. All rights reserved.
//

#import "NRPDFReaderViewController.h"

@interface NRPDFReaderViewController ()

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

- (IBAction)closeAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}
@end
