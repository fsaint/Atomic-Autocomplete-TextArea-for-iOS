//
//  ACArrayDataSource.m
//  AutoCompleteCell
//
//  Created by Felipe Saint-Jean on 1/21/14.
//
//

#import "ACArrayDataSource.h"
@implementation ACDictionaryObject
-(NSString *)description{
    return [self.values objectForKey:self.display_key];
}
@end

@implementation ACArrayDataSource

-(id)initWithObjects:(NSArray *)arr displayKey:(NSString *)display_key{
    
    self = [super init];
    if (self){
        self.display_key = display_key;
        self.search_keys = @[display_key];
        NSMutableArray *objs = [NSMutableArray array];
        for (NSDictionary *d in arr){
            ACDictionaryObject *dobj = [[ACDictionaryObject alloc] init];
            dobj.values = d;
            dobj.display_key = self.display_key;
            [objs addObject:dobj];
            
        }
        self.objects = objs;
    }
    
    return self;
}



-(void)cancel{

}
-(void)getSuggestionsFor:(NSString *)searchString withCallback:(void (^)(NSArray *suggestions))update{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF contains[cd] %@)", searchString];
    NSMutableArray *selection = [NSMutableArray array];
    for (ACDictionaryObject *d in self.objects){
        BOOL match = NO;
        
        for (NSString *k in self.search_keys)
            match = match || [predicate evaluateWithObject:[d.values objectForKey:k]];
        
                              
        if (match)
            [selection addObject:d];
            
        
    }
    
    update(selection);
    
}
@end
