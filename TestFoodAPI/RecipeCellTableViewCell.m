//
//  RecipeCellTableViewCell.m
//  TestFoodAPI
//
//  Created by Bahram Haddadi on 2016-03-23.
//  Copyright © 2016 Bahram Haddadi. All rights reserved.
//

#import "RecipeCellTableViewCell.h"
#import "ImageCacheManager.h"
#import "Recipe.h"

@interface RecipeCellTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgRecipe;
@property (weak, nonatomic) IBOutlet UILabel *lblRecipeName;
@property (weak, nonatomic) IBOutlet UILabel *lblRecipeIngredients;
@end

@implementation RecipeCellTableViewCell

+(NSString*)getNibName{
    return @"RecipeCellTableViewCell";
}

+(NSString*)getReusableIdentifier{
    return @"RecipeCellTableViewCell";
}

+(CGFloat)cellHeighht{
    return 102;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)prepareForReuse{
    self.lblRecipeName.text = @"";
    self.lblRecipeIngredients.text = @"";
    self.imgRecipe.image = [UIImage imageNamed:@"placeholder"];
}

-(void)setRecipeData:(NSDictionary*)recipe{
    NSString *title = recipe[@"title"];
    NSString *imageUrl = recipe[@"thumbnail"];
    self.lblRecipeName.text = [title stringByReplacingOccurrencesOfString:@"\n" withString:@"" ];
    self.lblRecipeIngredients.text = recipe[@"ingredients"];
    self.imgRecipe.image = [UIImage imageNamed:@"placeholder"];
    
    [[ImageCacheManager sharedInstance] loadImage:imageUrl complition:^(UIImage *image, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imgRecipe.image = image;
        });
    }];
}

-(void)setRecipe:(Recipe*)recipe{
    self.imgRecipe.image = [UIImage imageNamed:@"placeholder"];
    self.lblRecipeName.text = recipe.title;
    
    [[ImageCacheManager sharedInstance] loadImage:recipe.imageUrl complition:^(UIImage *image, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imgRecipe.image = image;
        });
    }];    
}


@end
