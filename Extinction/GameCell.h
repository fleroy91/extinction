//
//  GameCell.h
//  ToDoList
//
//  Created by Frédéric Leroy on 06/03/2014.
//  Copyright (c) 2014 Frédéric Leroy. All rights reserved.
//

#import <Foundation/Foundation.h>

enum CELL_KIND {
    none = 0,
    cross,
    through,
    left_right,
    right_left,
    y_inv_left,
    y_inv_right,
    y_left,
    y_right,
    water_both,
    water_left,
    water_right,
    fire,
    hider_all,
    hider_left,
    hider_right
    };

enum CELL_INPUT {
    left,
    right
};

@interface GameCell : NSObject
@property   enum CELL_KIND kind;
@property   enum CELL_KIND water_kind;
@property   NSInteger width;
@property   NSInteger height;
@property   NSInteger col;
@property   UIImage *image;

- (Boolean)leftExitRight;
- (Boolean)leftExitLeft;
- (Boolean)rightExitLeft;
- (Boolean)RightExitRight;
- (Boolean)canExitRight;
- (Boolean)canExitLeft;
- (Boolean)canInputLeft;
- (Boolean)canInputRight;
- (Boolean)isWater;
- (Boolean)isFire;
- (NSString *)imageName;

- (void)refreshImage;
- (UIImage *)getImage;

- (Boolean)chooseInputRight;
- (Boolean)chooseInputLeft;

- (id)init:(enum CELL_KIND)kind;

+ (NSInteger)nbKinds;
+ (NSInteger)nbKindsForWater;
+ (NSInteger)nbKindsForCells;

@end
