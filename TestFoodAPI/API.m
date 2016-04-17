//
//  API.m
//  TestFoodAPI
//
//  Created by Bahram Haddadi on 2016-03-08.
//  Copyright © 2016 Bahram Haddadi. All rights reserved.
//

#import "API.h"

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
        urlString = [NSString stringWithFormat:@"%@&p=%d",urlString,(int)page];
    }
    
    
    NSURL *url = url = [NSURL URLWithString:urlString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(data !=nil && error==nil){
            NSError *e = nil;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
            NSArray *retVal = dict[@"results"];
            completion([retVal copy],e);
        }else{
            completion([NSArray array],error);
        }
    }] resume];
}

@end
