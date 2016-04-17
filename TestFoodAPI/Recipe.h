//
//  Recipe.h
//  TestFoodAPI
//
//  Created by Bahram Haddadi on 2016-03-08.
//  Copyright © 2016 Bahram Haddadi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recipe : NSObject

@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *href;
@property (strong,nonatomic) NSString *ingredients;
@property (strong,nonatomic) NSString *thumbnail;

@end
