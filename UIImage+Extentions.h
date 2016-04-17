//
//  UIImage+Extentions.h
//  TestFoodAPI
//
//  Created by Bahram Haddadi on 2016-03-22.
//  Copyright © 2016 Bahram Haddadi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ImageLoadCallBack) (UIImage* image, NSError *error);

@interface UIImage (Extentions)

+(void)loadImage:(NSString*)url complition:(ImageLoadCallBack)complition;
-(void)cacheByName:(NSString*)name;

@end
