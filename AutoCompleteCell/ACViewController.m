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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.textArea loadItems:@[@"Felipe Saint-Jean",@"Test User",@"Jack"]];
    
    ACArrayDataSource *arr = [[ACArrayDataSource alloc] initWithObjects:@[@{@"name":@"Felipe Saint-Jean"},@{@"name":@"Domino"}] displayKey:@"name"];
    self.textArea.placeholder = @"Placeholder ...";
    
    self.textArea.autoCompleteDataSource = arr;
    self.textArea.short_list = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"Ñ",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
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
