//
//  ACItemCell.m
//  AutoCompleteCell
//
//  Created by Felipe Saint-Jean on 10/22/14.
//
//

#import "ACItemCell.h"
@interface ACItemCell ()

@property (nonatomic,strong) UILabel *collection_name;
@end
@implementation ACItemCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){
        
    }
    
    return self;

}


-(void)layoutSubviews{
    [super layoutSubviews];
    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
