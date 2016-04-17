//
//  API.h
//  TestFoodAPI
//
//  Created by Bahram Haddadi on 2016-03-08.
//  Copyright © 2016 Bahram Haddadi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CallBack) (NSArray* result, NSError *error);

@interface API : NSObject

+(API*)sharedInstance;

-(void)getRecipesByIngredients:(NSString*)ingredients criteria:(NSString*)criteria page:(NSInteger)page completion:(CallBack)completion;

@end
