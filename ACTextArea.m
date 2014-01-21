//
//  ACTextArea.m
//  AutoCompleteCell
//
//  Created by Felipe Saint Jean on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "ACTextArea.h"
#define AC_TEXT_HEIGHT 32.0
#define AC_SPACING 2.0
#define AC_CELL_HEIGHT 40.0

@interface ACTextArea ()

-(void)hideAutoTable;

@end

@implementation ACTextArea
-(void)initialize{
    self.bubbles = [[NSMutableArray alloc] init];
    self.items = [[NSMutableArray alloc] init];
    text = [[UITextView alloc] initWithFrame:CGRectZero];
    text.autocorrectionType = UITextAutocorrectionTypeNo;
    text.autocapitalizationType = UITextAutocapitalizationTypeNone;
    text.returnKeyType = UIReturnKeyDone;
    [self addSubview:text];
    text.delegate = self;
    self.font = [UIFont systemFontOfSize:18.0];
    text.font = self.font;
    //text.contentInset = UIEdgeInsetsMake(1.0, 1.0, 12.0, 0.0);
    [text  setTextContainerInset:UIEdgeInsetsMake(4, 1, 0.0, 0)];
    
      
    autocomplete = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    autocomplete.delegate = self;
    autocomplete.rowHeight = AC_CELL_HEIGHT;
    autocomplete.dataSource = self;
    autocomplete.hidden = YES;
  
    keyboardFrame = CGRectZero;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    //keyboardFrame
    
    self.userInteractionEnabled = YES;
}

- (void) keyboardDidHide:(NSNotification*)notification {
    keyboardFrame = CGRectZero;
 //   [self setNeedsLayout];
}

- (void) keyboardDidShow:(NSNotification*)notification {
    CGRect keyboardFrameOrig = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    UIWindow *window = [[[UIApplication sharedApplication] windows]objectAtIndex:0];
    UIView *mainSubviewOfWindow = window.rootViewController.view;
    keyboardFrame = [mainSubviewOfWindow convertRect:keyboardFrameOrig fromView:window];
    [self setNeedsLayout];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self initialize];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self initialize];
    }
    return self;
}

-(NSString *)nameForItem:(id)item{
    if ([[item class] isSubclassOfClass:[NSString class]]){
        return (NSString *)item;
    }
    else
    {
        id<ACAutoCompleteElement>el = (id<ACAutoCompleteElement>)item;        
        
        NSString *fullUserInfo;
        if ([el respondsToSelector:@selector(getDisplayText)])
            fullUserInfo = [el getDisplayText];
        else
            fullUserInfo = [el description];
        NSRange emailRange = [fullUserInfo rangeOfString:@"<"];

        if (emailRange.location == NSNotFound) 
            return fullUserInfo;        
        else 
            return [fullUserInfo substringToIndex:emailRange.location];
    }
}

-(NSString *)emailForItem:(id)item
{
    if ([[item class] isSubclassOfClass:[NSString class]]){
        return (NSString *)item;
    }
    else
    {
        id<ACAutoCompleteElement>el = (id<ACAutoCompleteElement>)item;        
        
        NSString *fullUserInfo;
        if ([el respondsToSelector:@selector(getDisplayText)])
            fullUserInfo = [el getDisplayText];
        else
            fullUserInfo = [el description];
        
        
        NSRange emailRange = [fullUserInfo rangeOfString:@"<"];
        
        if (emailRange.location == NSNotFound) 
            return @"";        
        else 
        {
            NSString *subString = [fullUserInfo substringWithRange:NSMakeRange(0, [fullUserInfo length] - 1)];
            return [subString substringFromIndex:emailRange.location + 1];
        }
    }
}

-(void)addItem:(id<ACAutoCompleteElement>)it{
    [_items addObject:it];
    ACBubble *b = [[ACBubble alloc] initWithFrame:CGRectZero];
    b.textarea = self;
    [b setFont:_font];
    
    NSRange emailRange = [[self nameForItem:it] rangeOfString:@"<"];
    if (emailRange.location == NSNotFound) {
        [b setLabelText:[self nameForItem:it]];
    }
    else {
        [b setLabelText:[[self nameForItem:it] substringToIndex:emailRange.location]];
    }
    
    [_bubbles addObject:b];
    [self addSubview:b];

}
-(BOOL)resignFirstResponder{
    [text resignFirstResponder];
    return [super resignFirstResponder];
}
-(void)loadItems:(NSArray *)newItems{
   
    for (int i=0;i<[newItems count];i++){
        [self addItem:[newItems objectAtIndex:i]];
    }
    [self hideAutoTable];
}
-(void)showAutotable{
    CGRect tfr = text.frame;
    // right below the textx
    // delta to keyboard
    
    
    CGRect fr = CGRectMake(tfr.origin.x, tfr.origin.y +tfr.size.height  , tfr.size.width, [_filtered_autocomp count] * AC_CELL_HEIGHT);
    
    UIWindow *window = [[[UIApplication sharedApplication] windows]objectAtIndex:0];
    
    UIView *mainSubviewOfWindow = [[window subviews] lastObject];
    CGRect window_fr = [mainSubviewOfWindow convertRect:fr fromView:self];
    
    if (keyboardFrame.origin.y != 0.0)
        fr.size.height = MIN(fr.size.height,keyboardFrame.origin.y - window_fr.origin.y);
    else{
        //fr.size.height = MIN(fr.size.height,  - window_fr.origin.y);
    }
    autocomplete.frame =   [mainSubviewOfWindow convertRect:fr fromView:self];
    autocomplete.hidden = NO;
    
    [mainSubviewOfWindow addSubview:autocomplete];
    [autocomplete scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [autocomplete reloadData];
}

-(void)hideAutoTable{
    autocomplete.hidden = YES;
    [autocomplete removeFromSuperview];
}

-(void)deleteItem:(int)index{
    if (index >=[_bubbles count])
        return;
    [_items removeObjectAtIndex:index];
    ACBubble *b = [_bubbles objectAtIndex:index];
    [_bubbles removeObjectAtIndex:index];
    [b removeFromSuperview];
    [self setNeedsLayout];
}

-(void)deleteItemWithBubble:(ACBubble *)bb{
    int index = [_bubbles indexOfObject:bb];
    [self deleteItem:index];
}


-(void)layoutSubviews{
    int row = 0;
    CGFloat x_advance=AC_SPACING/2.0;
    for (int i=0;i<[_items count];i++){
        
        NSString *it = [self nameForItem:[_items objectAtIndex:i]];
        
        
        ACBubble *b = [_bubbles objectAtIndex:i];
        
        CGSize z =[it sizeWithFont:self.font constrainedToSize:CGSizeMake(300.0, AC_TEXT_HEIGHT)];
        CGFloat w = z.width + AC_TEXT_HEIGHT  /* <- this is space for the button that is a square AC_TEXT_HEIGHT x AC_TEXT_HEIGHT*/ + 18.0 /* <- for the inner padding*/;
        w  = ceilf(w);
        CGFloat x_loc = x_advance + AC_SPACING;
        if (x_advance + w > self.bounds.size.width){
            x_advance =w + AC_SPACING;
            row++;
            x_loc = AC_SPACING/2.0;
        }else{
            x_advance = x_advance + w + AC_SPACING;
        }

        b.frame =  CGRectMake(x_loc,  AC_SPACING / 2.0 + row * (AC_TEXT_HEIGHT + AC_SPACING) , w , AC_TEXT_HEIGHT);
        
    }
    if (x_advance + 200.0 > self.bounds.size.width){
        row++;
        x_advance=0.0;
    }
    CGFloat l_width = self.bounds.size.width - x_advance;
    text.frame = CGRectMake(x_advance, AC_SPACING / 2.0 + row * (AC_TEXT_HEIGHT + AC_SPACING)  ,l_width, AC_TEXT_HEIGHT);
    [text becomeFirstResponder];
}

-(void)checkInItem{
    
    if ([text.text length]==0)
        return;
    [self addItem:(id<ACAutoCompleteElement>)text.text];
    text.text = @"";
    [self setNeedsLayout];
}
-(void)checkInItem:(id)obj{
    [self addItem:obj];
    text.text = @"";
    [self setNeedsLayout];
}
-(void)fireAutoComplete:(NSString *)search{
    [_autoCompleteDataSource getSuggestionsFor:search withCallback:^(NSArray *arr){
       
        self.filtered_autocomp = arr;
        [autocomplete reloadData];
        if ([arr count] > 0 && [text.text length] >= 2)
            [self showAutotable];
        else
            [self hideAutoTable];
    }];
   
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSArray *)getSelectedItems{
    return _items;
}

#pragma mark -
#pragma mark UITextViewDelegate methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)intex
{
    [_autoCompleteDataSource cancel];
    ACBubble *last = [_bubbles lastObject];
    if ([textView.text length] == 0 && [intex length] ==0){
        
        if (last.selected){
            [self deleteItem:[_bubbles count]-1];
        }else{
            last.selected = YES;
        }
        [self hideAutoTable];
        return NO;
    }else if ([intex isEqualToString:@","] || [intex isEqualToString:@"\n"]){
        [self checkInItem];
        [self hideAutoTable];
        last.selected = NO;
        return NO;
    }
    last.selected = NO;
    
    if ([intex length] == 0) { //estoy borrando y debo autocompletar por la string menos el ultimo caracter
        NSString *autoCompleteString = [textView.text substringToIndex:[textView.text length] - 1];
        if ([autoCompleteString length] >= 2) {
            [self fireAutoComplete:autoCompleteString];
        } else {
            [self hideAutoTable];
        }
    } else { //debo autocompletar por la string nueva
        NSString *autoCompleteString = [NSString stringWithFormat:@"%@%@", textView.text, intex];
        if ([autoCompleteString length] >= 2) {
            [self fireAutoComplete:autoCompleteString];
        } else {
            [self hideAutoTable];
        }
    }
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{

}
#pragma mark -
#pragma mark Autocompletion methods

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_filtered_autocomp count];
}
-(int)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    static NSString *cell_name = @"AUTOCOMPLETE CELL";
    cell = [tableView dequeueReusableCellWithIdentifier:cell_name];
    if (cell == nil){
        cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell_name];
    }
    
    if (indexPath.row < [_filtered_autocomp count]) {
        cell.textLabel.text = [self nameForItem:[_filtered_autocomp objectAtIndex:indexPath.row]];
        cell.detailTextLabel.text = [self emailForItem:[_filtered_autocomp objectAtIndex:indexPath.row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < [_filtered_autocomp count]) {
        id object = [_filtered_autocomp objectAtIndex:indexPath.row];
        [self checkInItem:object];
    }
    [self hideAutoTable];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [text becomeFirstResponder];
}
@end
