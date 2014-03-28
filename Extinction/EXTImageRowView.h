//
//  XYZImageRowView.h
//  ToDoList
//
//  Created by Frédéric Leroy on 04/03/2014.
//  Copyright (c) 2014 Frédéric Leroy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameRow.h"

@interface EXTImageRowView : UIView

@property CGFloat startX;
@property CGFloat currentX;
@property NSInteger width;
@property NSInteger height;
@property NSInteger nbCols;


- (IBAction)panRow:(UIPanGestureRecognizer *)gestureRecognizer;
- (id)initWithFrame:(CGRect)frame andGameRow:(GameRow *)gameRow;
- (id)initHiderWithFrame:(CGRect)frame andGameRow:(GameRow *)gameRow andInput:(enum CELL_INPUT)input andWidth:(NSInteger)width;
- (void)refreshOpacityOfImages;

@end
