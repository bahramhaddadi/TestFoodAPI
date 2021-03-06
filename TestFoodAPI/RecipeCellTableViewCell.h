//
//  RecipeCellTableViewCell.h
//  TestFoodAPI
//
//  Created by Bahram Haddadi on 2016-03-23.
//  Copyright © 2016 Bahram Haddadi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Recipe;

@interface RecipeCellTableViewCell : UITableViewCell

+(NSString*)getNibName;
+(NSString*)getReusableIdentifier;
+(CGFloat)cellHeighht;

-(void)setRecipeData:(NSDictionary*)recipe;
-(void)setRecipe:(Recipe*)recipe;

@end
