//
//  API.m
//  TestFoodAPI
//
//  Created by Bahram Haddadi on 2016-03-08.
//  Copyright © 2016 Bahram Haddadi. All rights reserved.
//

// food2fork
// key=6fe08d2ad00e41137f7c010398ae8457

#import "API.h"
#import "Recipe.h"

const NSString *ApiKey = @"6fe08d2ad00e41137f7c010398ae8457";

@implementation API

+(API*)sharedInstance{
    static API *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        service = [[API alloc] init];
    });
    
    return service;
}

-(API *)init{
    self = [super init];
    
    if(self){
        
    }
    
    return self;
}

-(void)getRecipesByIngredients:(NSString*)ingredients criteria:(NSString*)criteria page:(NSInteger)page completion:(CallBack)completion{
    NSString *urlString;
    if(criteria.length>0){
        urlString = [NSString stringWithFormat:@"http://www.recipepuppy.com/api/?i=%@&q=%@",ingredients,criteria];
    }else{
        urlString = [NSString stringWithFormat:@"http://www.recipepuppy.com/api/?i=%@",ingredients];
    }
    
    if(page>0){
        urlString = [NSString stringWithFormat:@"%@&page=%d",urlString,(int)page];
    }
    
    
    NSURL *url = url = [NSURL URLWithString:urlString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(data !=nil && error==nil){
            NSError *e = nil;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
            NSArray *retVal = dict[@"recipes"];
            completion([retVal copy],e);
        }else{
            completion([NSArray array],error);
        }
    }] resume];
}

-(void)getRecipesByIngredients:(NSString*)ingredients page:(NSInteger)page completion:(RecipeCallBack)completion{
    NSString *urlString = [NSString stringWithFormat:@"http://food2fork.com/api/search?key=%@&q=%@",ApiKey,ingredients];
    
    if(page>0){
        urlString = [NSString stringWithFormat:@"%@&page=%d",urlString,(int)page];
    }
    
    NSURL *url = url = [NSURL URLWithString:urlString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(data !=nil && error==nil){
            NSError *e = nil;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
            NSArray *rawArray = dict[@"recipes"];
            NSArray<Recipe*> *recipies = [self parseData:rawArray];
            completion([recipies copy], e);
        }else{
            completion([NSArray array],error);
        }
    }] resume];
}

-(NSArray<Recipe*>*)parseData:(NSArray*)rawArray{
    NSMutableArray<Recipe*> *recipies = [NSMutableArray array];
    for (NSDictionary *receipeDic in rawArray) {
        Recipe *recipe = [[Recipe alloc] init];
        recipe.title = receipeDic[@"title"];
        recipe.imageUrl = receipeDic[@"image_url"];
        recipe.hrefShortDesc = receipeDic[@"f2f_url"];
        recipe.hrefLongtDesc = receipeDic[@"source_url"];
        [recipies addObject:recipe];
    }
    
    return recipies;
}

@end
