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
@optional
-(NSString *)getDetailText;
-(NSString *)getCollection;
@end

@protocol ACAutoCompleteDataSource <NSObject>

-(void)cancel;
-(void)getSuggestionsFor:(NSString *)searchString withCallback:(void (^)(NSArray *suggestions))update;

@end


@interface ACTextArea : UIScrollView <UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>

// this two should be the same length
// This is fot the input
@property (nonatomic) UITextView *text;
@property (nonatomic) UITableView *autocomplete;

@property (nonatomic, assign) CGRect keyboardFrame;

@property (nonatomic,strong) NSArray *short_list;

@property (nonatomic, copy) void (^finishedEditing)(ACTextArea *);
@property (nonatomic,strong) NSMutableArray *items;
@property (nonatomic,strong) NSMutableArray *bubbles;
@property (nonatomic,strong) NSString *placeholder;
@property (nonatomic, readwrite, strong) NSArray *filtered_autocomp;
@property (nonatomic, readwrite, strong) id<ACAutoCompleteDataSource> autoCompleteDataSource;
@property (nonatomic, readwrite, strong) UIFont *font;
@property (nonatomic,assign) BOOL allow_new_element;
@property (nonatomic,assign) int number_of_keys_needed;
-(void)loadItems:(NSArray *)newItems;
-(void)deleteItemWithBubble:(ACBubble *)bb;
-(NSArray *)getSelectedItems;
-(void)checkInItem;
-(void)hideAutoTable;

@end
