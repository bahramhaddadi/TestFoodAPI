//
//  SearchViewController.m
//  TestFoodAPI
//
//  Created by Bahram Haddadi on 2016-03-08.
//  Copyright © 2016 Bahram Haddadi. All rights reserved.
//

#import "SearchViewController.h"
#import "WebRecipeDetailViewController.h"
#import "UIImage+Extentions.h"
#import "API.h"
#import "ImageCacheManager.h"
#import "RecipeCellTableViewCell.h"

@interface SearchViewController () <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property (strong,nonatomic) NSMutableArray *recipes;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *txtIngredients;
@property (weak, nonatomic) IBOutlet UITextField *txtSearchCriteria;
@property NSInteger selectedRecipeindex;
@property (weak, nonatomic) IBOutlet UIView *vwSpinnerBG;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong,nonatomic) ImageCacheManager *cacheManager;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.recipes = [NSMutableArray array];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.cacheManager = [ImageCacheManager sharedInstance];
    [self.tableView registerNib:[UINib nibWithNibName:[RecipeCellTableViewCell getNibName] bundle:nil] forCellReuseIdentifier:[RecipeCellTableViewCell getReusableIdentifier]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSearch_click:(id)sender {
    [self showSpinner:YES];
    API *api = [API sharedInstance];
    NSString *ingredients = [self.txtIngredients.text stringByReplacingOccurrencesOfString:@" " withString:@","];
    __weak typeof(self)weakself = self;
    [api getRecipesByIngredients:ingredients criteria:self.txtSearchCriteria.text page:0 completion:^(NSArray *result, NSError *error) {
        [weakself showSpinner:NO];
        if(!error){
            weakself.recipes = [result mutableCopy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.tableView reloadData];
            });
        }else{
            NSLog(@"Error on loading");
        }
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showDetail"]){
        WebRecipeDetailViewController *vc = segue.destinationViewController;
        NSDictionary *recipe = self.recipes[self.selectedRecipeindex];
        vc.webUrl = recipe[@"href"];
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    if ([textView.text containsString:@" find"]) {
        NSLog(@"remove word and search");
    }
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.recipes.count == ((int)self.recipes.count/10)*10 && self.recipes.count>0){
        return self.recipes.count + 1;
    }else{
        return self.recipes.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==self.recipes.count){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loadMoreID"];
        return cell;
    }else{
        NSDictionary *recipe = self.recipes[indexPath.row];
        RecipeCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[RecipeCellTableViewCell getReusableIdentifier]];
        [cell setRecipeData:recipe];
        return cell;
        
//        cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
//        NSDictionary *recipe = self.recipes[indexPath.row];
//        NSString *title = recipe[@"title"];
//        NSString *imageUrl = recipe[@"thumbnail"];
//        cell.textLabel.text = [title stringByReplacingOccurrencesOfString:@"\n" withString:@"" ];
//        cell.detailTextLabel.text = recipe[@"ingredients"];        
//        cell.imageView.image = [UIImage imageNamed:@"placeholder"];
//
//        [self.cacheManager loadImage:imageUrl complition:^(UIImage *image, NSError *error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                cell.imageView.image = image;
//            });
//
//        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==self.recipes.count){
        return 40;
    }else{
        return [RecipeCellTableViewCell cellHeighht];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row==self.recipes.count){
        NSLog(@"Load More .........");
        NSInteger pageNo = (self.recipes.count/10) + 1;
        NSString *ingredients = [self.txtIngredients.text stringByReplacingOccurrencesOfString:@" " withString:@","];
        
        API *api = [API sharedInstance];
        __weak typeof(self)weakself = self;
        [api getRecipesByIngredients:ingredients criteria:self.txtSearchCriteria.text page:pageNo completion:^(NSArray *result, NSError *error) {
            [weakself showSpinner:NO];
            if(!error){
                [weakself.recipes addObjectsFromArray:result];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself.tableView reloadData];
                });
            }else{
                NSLog(@"Error on loading");
            }
        }];

    }else{
        self.selectedRecipeindex = indexPath.row;
        [self performSegueWithIdentifier:@"showDetail" sender:self];
    }
}

#pragma mark - Helper Methods
-(void)showSpinner:(BOOL)show{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.vwSpinnerBG.hidden = !show;
        self.spinner.hidden = !show;
        if (show) [self.spinner startAnimating];
        else [self.spinner stopAnimating];
    });
}
@end
