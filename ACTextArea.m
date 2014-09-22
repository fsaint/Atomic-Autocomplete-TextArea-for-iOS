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

@property (nonatomic,assign) BOOL short_list_mode_on;
-(void)hideAutoTable;

@end

@implementation ACTextArea
-(void)initialize{
    self.bubbles = [[NSMutableArray alloc] init];
    self.items = [[NSMutableArray alloc] init];
    self.text = [[UITextView alloc] initWithFrame:CGRectZero];
    self.text.autocorrectionType = UITextAutocorrectionTypeNo;
    self.text.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.text.returnKeyType = UIReturnKeyDone;
    [self addSubview:self.text];
    self.text.delegate = self;
    self.font = [UIFont systemFontOfSize:18.0];
    self.text.font = self.font;
    //text.contentInset = UIEdgeInsetsMake(1.0, 1.0, 12.0, 0.0);
    [self.text  setTextContainerInset:UIEdgeInsetsMake(4, 1, 0.0, 0)];
    
      
    self.autocomplete = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.autocomplete.delegate = self;
    self.autocomplete.rowHeight = AC_CELL_HEIGHT;
    self.autocomplete.dataSource = self;
    self.autocomplete.hidden = YES;
  
    self.keyboardFrame = CGRectZero;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    //keyboardFrame
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];

    self.userInteractionEnabled = YES;
    self.allow_new_element = YES;
    self.number_of_keys_needed = 2;
    
    self.contentSize = self.frame.size;
    self.clipsToBounds = YES;
    
}

-(void)setPlaceholder:(NSString *)placeholder{

    _placeholder = placeholder;
    [self activatePlacehlder:self.text];
}


-(void)didTap:(UITapGestureRecognizer *)rec{
    [self.text becomeFirstResponder];
}
- (void) keyboardDidHide:(NSNotification*)notification {
    self.keyboardFrame = CGRectZero;
 //   [self setNeedsLayout];
}

- (void) keyboardDidShow:(NSNotification*)notification {
    CGRect keyboardFrameOrig = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    UIWindow *window = [[[UIApplication sharedApplication] windows]objectAtIndex:0];
    UIView *mainSubviewOfWindow = window.rootViewController.view;
    self.keyboardFrame = [mainSubviewOfWindow convertRect:keyboardFrameOrig fromView:window];
    
    [self resizeTable];
    [self setNeedsLayout];
    [self adjustScroll];
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
        return fullUserInfo;
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
        
        if ([el respondsToSelector:@selector(getDetailText)])
            return [el getDetailText];
        
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
    [self.text resignFirstResponder];
    return [super resignFirstResponder];
}
-(void)loadItems:(NSArray *)newItems{
   
    for (int i=0;i<[newItems count];i++){
        [self addItem:[newItems objectAtIndex:i]];
    }
    [self hideAutoTable];
}

-(void)resizeTable{
    CGRect tfr = self.text.frame;
    // right below the textx
    // delta to keyboard
    
    CGRect fr = CGRectZero;
    if (self.short_list_mode_on)
        fr = CGRectMake(tfr.origin.x, tfr.origin.y +tfr.size.height  , tfr.size.width, [_short_list count] * AC_CELL_HEIGHT);
    else
        fr = CGRectMake(tfr.origin.x, tfr.origin.y +tfr.size.height  , tfr.size.width, [_filtered_autocomp count] * AC_CELL_HEIGHT);
    
    UIWindow *window = [[[UIApplication sharedApplication] windows]objectAtIndex:0];
    
    UIView *mainSubviewOfWindow = [[window subviews] lastObject];
    CGRect window_fr = [mainSubviewOfWindow convertRect:fr fromView:self];
    
    if (self.keyboardFrame.origin.y != 0.0) {
        fr.size.height = MIN(fr.size.height,self.keyboardFrame.origin.y - window_fr.origin.y);
    }
    else if (self.keyboardFrame.origin.x != 0.0) {
        fr.size.height = MIN(fr.size.height, self.keyboardFrame.size.width - (window_fr.origin.x + window_fr.size.width));
    }
    self.autocomplete.frame =   [mainSubviewOfWindow convertRect:fr fromView:self];

}

-(void)showAutotable{
    [self resizeTable];
    self.autocomplete.hidden = NO;
    
    UIWindow *window = [[[UIApplication sharedApplication] windows]objectAtIndex:0];
    UIView *mainSubviewOfWindow = [[window subviews] lastObject];
    [mainSubviewOfWindow addSubview:self.autocomplete];
    
    //if (self.short_list_mode_on && [self.short_list count])
    [self.autocomplete reloadData];
    
    [self.autocomplete scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
}

-(void)hideAutoTable{
    self.autocomplete.hidden = YES;
    [self.autocomplete removeFromSuperview];
}

-(void)deleteItem:(int)index{
    if (index >=[_bubbles count])
        return;
    [_items removeObjectAtIndex:index];
    ACBubble *b = [_bubbles objectAtIndex:index];
    [_bubbles removeObjectAtIndex:index];
    [b removeFromSuperview];
    [self setNeedsLayout];
    [self adjustScroll];
}

-(void)deleteItemWithBubble:(ACBubble *)bb{
    int index = [_bubbles indexOfObject:bb];
    [self deleteItem:index];
}


-(void)adjustScroll{
    if (self.contentSize.height > self.bounds.size.height){
        CGPoint bottomOffset = CGPointMake(0, self.contentSize.height - self.bounds.size.height);
        [self setContentOffset:bottomOffset animated:YES];
        NSLog(@",to %f",bottomOffset.y);
    }else{
        [self setContentOffset:CGPointMake(0.0, 0.0)];
        
        //NSLog(@"Adjust SCroll to Zero");
    }
    
    

}
-(void)layoutSubviews{
    int row = 0;
    CGFloat x_advance=AC_SPACING/2.0;
    for (int i=0;i<[_items count];i++){
        
        NSString *it = [self nameForItem:[_items objectAtIndex:i]];
        
        
        ACBubble *b = [_bubbles objectAtIndex:i];
        
        CGRect textRect = [it boundingRectWithSize:CGSizeMake(300.0, AC_TEXT_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil];
        CGSize z = textRect.size;
        
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
    self.text.frame = CGRectMake(x_advance, AC_SPACING / 2.0 + row * (AC_TEXT_HEIGHT + AC_SPACING)  ,l_width, AC_TEXT_HEIGHT);
    //[text becomeFirstResponder];
    
    //NSLog(@"Set Text Frame");
    
    [self resizeTable];
    
    

    self.contentSize = CGSizeMake(self.bounds.size.width, AC_SPACING / 2.0 + row * (AC_TEXT_HEIGHT + AC_SPACING) + AC_TEXT_HEIGHT);
    
    
    
}

-(void)checkInItem{
    
    if ([self.text.text length]==0)
        return;
    
    
    if (self.allow_new_element)
        [self addItem:(id<ACAutoCompleteElement>)self.text.text];
    self.text.text = @"";
    [self layoutSubviews];
    [self adjustScroll];
}

-(void)checkInItem:(id)obj{
    
    [self addItem:obj];
    self.text.text = @"";
    [self layoutSubviews];
    [self adjustScroll];
}
-(void)fireAutoComplete:(NSString *)search{
    [_autoCompleteDataSource getSuggestionsFor:search withCallback:^(NSArray *arr){
       
        self.filtered_autocomp = arr;
        [self.autocomplete reloadData];
        if ([arr count] > 0 && [self.text.text length] >= 2)
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

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:self.placeholder]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    
    if (self.short_list){
        self.short_list_mode_on = YES;
        [self showAutotable];
    }
    [textView becomeFirstResponder];
}

- (void)activatePlacehlder:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = self.placeholder;
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    [self checkInItem];
    [self hideAutoTable];
    
    if ([self getSelectedItems] <= 0) {
        [self activatePlacehlder:textView];
    }
    
    [textView resignFirstResponder];
    
    if (self.finishedEditing)
        self.finishedEditing(self);
    
}
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
        
        if (self.short_list){
            self.short_list_mode_on = YES;
            [self showAutotable];
        }else
            [self hideAutoTable];
        
        return NO;
    }else if ([intex isEqualToString:@"\n"] && !self.allow_new_element){
        if (self.finishedEditing)
            self.finishedEditing(self);

    }else if ([intex isEqualToString:@","] || [intex isEqualToString:@"\n"]){
        [self checkInItem];
        if (self.short_list){
            self.short_list_mode_on = YES;
            [self showAutotable];
        }else
            [self hideAutoTable];
        last.selected = NO;
        return NO;
    }
    last.selected = NO;
    
    if ([intex length] == 0) { //estoy borrando y debo autocompletar por la string menos el ultimo caracter
        NSString *autoCompleteString = [textView.text substringToIndex:[textView.text length] - 1];
        if ([autoCompleteString length] >= self.number_of_keys_needed) {
            self.short_list_mode_on = NO;
            [self fireAutoComplete:autoCompleteString];
            
        } else if (self.short_list){
            self.short_list_mode_on = YES;
            [self showAutotable];
        }else {
            [self hideAutoTable];
        }
    } else { //debo autocompletar por la string nueva
        NSString *autoCompleteString = [NSString stringWithFormat:@"%@%@", textView.text, intex];
        if ([autoCompleteString length] >= self.number_of_keys_needed) {
            self.short_list_mode_on = NO;
            [self fireAutoComplete:autoCompleteString];
        } else if (self.short_list_mode_on){
            [self showAutotable];
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
    if (_short_list_mode_on)
        return [_short_list count];
    else
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
    
    
    if (_short_list_mode_on){
        cell.textLabel.text = [self nameForItem:[_short_list objectAtIndex:indexPath.row]];
        cell.detailTextLabel.text = [self emailForItem:[_short_list objectAtIndex:indexPath.row]];

    }else if (indexPath.row < [_filtered_autocomp count]) {
        cell.textLabel.text = [self nameForItem:[_filtered_autocomp objectAtIndex:indexPath.row]];
        cell.detailTextLabel.text = [self emailForItem:[_filtered_autocomp objectAtIndex:indexPath.row]];
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_short_list_mode_on){
        id object = [_short_list objectAtIndex:indexPath.row];
        [self checkInItem:object];
        [self showAutotable];

    
    }else if (indexPath.row < [_filtered_autocomp count]) {
        id object = [_filtered_autocomp objectAtIndex:indexPath.row];
        [self checkInItem:object];
        
        if (self.short_list){
            self.short_list_mode_on = YES;
            [self showAutotable];
        }else
            [self hideAutoTable];
    }
    
}

-(BOOL )becomeFirstResponder{
    return [self.text becomeFirstResponder];
}

@end
