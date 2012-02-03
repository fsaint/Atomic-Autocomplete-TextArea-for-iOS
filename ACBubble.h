//
//  ACBubble.h
//  AutoCompleteCell
//
//  Created by Felipe Saint Jean on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  ACTextArea;
@interface ACBubble : UIView{
    UIButton *delete_button;
    UILabel *text_label;
    ACTextArea *textarea;
    
    BOOL selected;
    
    UIColor *ac_background_color;
    UIColor *ac_text_color;
    UIColor *ac_background_selected;
}
@property (nonatomic, readwrite, retain) ACTextArea *textarea;
@property (nonatomic, readwrite, assign, getter=isSelected,setter = setSelected:) BOOL selected;
@property (nonatomic, readwrite, retain) UIColor *ac_background_color;
@property (nonatomic, readwrite, retain) UIColor *ac_text_color;
@property (nonatomic, readwrite, retain) UIColor *ac_background_selected;


-(void)setLabelText:(NSString *)s;
-(void)setFont:(UIFont *)font;
-(void)deleteItemWithBubble:(ACBubble *)bb;

@end
