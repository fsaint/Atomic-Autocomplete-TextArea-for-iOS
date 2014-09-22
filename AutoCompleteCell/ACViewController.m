//
//  ACViewController.m
//  AutoCompleteCell
//
//  Created by Felipe Saint Jean on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ACViewController.h"
#import "ACAddressBookDataSource.h"
#import "ACArrayDataSource.h"
@implementation ACViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.textArea loadItems:[NSArray arrayWithObjects:@"Felipe Saint-Jean",@"Test User",@"Jack", nil]];
    
    ACArrayDataSource *arr = [[ACArrayDataSource alloc] initWithObjects:@[@{@"name":@"Felipe Saint-Jean"},@{@"name":@"Domino"}] displayKey:@"name"];
    self.textArea.placeholder = @"Placeholder ...";
    
    self.textArea.autoCompleteDataSource = arr;
    self.textArea.short_list = @[@"A",@"B",@"C"];
    //[[ACAddressBookDataSource alloc] init];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


@end
