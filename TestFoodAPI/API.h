//
//  API.h
//  TestFoodAPI
//
//  Created by Bahram Haddadi on 2016-03-08.
//  Copyright © 2016 Bahram Haddadi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Recipe;

typedef void (^CallBack) (NSArray* result, NSError *error);

typedef void (^RecipeCallBack) (NSArray<Recipe*> *recipies, NSError *error);

@interface API : NSObject

+(API*)sharedInstance;

-(void)getRecipesByIngredients:(NSString*)ingredients criteria:(NSString*)criteria page:(NSInteger)page completion:(CallBack)completion;
-(void)getRecipesByIngredients:(NSString*)ingredients page:(NSInteger)page completion:(RecipeCallBack)completion;

@end
