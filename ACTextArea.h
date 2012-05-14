//
//  ACTextArea.h
//  AutoCompleteCell
//
//  Created by Felipe Saint Jean on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACBubble.h"

@protocol ACAutoCompleteElement <NSObject>
-(NSString *)getDisplayText;
@end

@protocol ACAutoCompleteDataSource <NSObject>

-(void)cancel;
-(void)getSuggestionsFor:(NSString *)searchString withCallback:(void (^)(NSArray *suggestions))update;

@end


@interface ACTextArea : UIView <UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    // this two should be the same length
    NSMutableArray *items;
    NSMutableArray *bubbles;

    // This is fot the input
    UITextView *text;
    UIFont *font;
    UITableView *autocomplete;
    NSArray *filtered_autocomp;
    
    id<ACAutoCompleteDataSource> autoCompleteDataSource;
    
    CGRect keyboardFrame;
}

@property (nonatomic, readwrite, retain) NSArray *filtered_autocomp;
@property (nonatomic, readwrite, retain) id<ACAutoCompleteDataSource> autoCompleteDataSource;
@property (nonatomic, readwrite, retain) UIFont *font;
-(void)loadItems:(NSArray *)newItems;
-(void)deleteItemWithBubble:(ACBubble *)bb;
-(NSArray *)getSelectedItems;
-(void)checkInItem;
-(void)hideAutoTable;

@end
