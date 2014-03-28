//
//  GameRow.h
//  ToDoList
//
//  Created by Frédéric Leroy on 06/03/2014.
//  Copyright (c) 2014 Frédéric Leroy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameCell.h"

@interface GameRow : NSObject

@property NSInteger rowIndex;
@property NSMutableArray *cells;
@property Boolean canMove;
@property CGFloat decalX;
@property NSInteger decalCellX;
@property UIView *view;

- (NSInteger)changeKindForRandomCell:(enum CELL_KIND)cell_kind;
- (void)changeCellForRandomKind:(NSInteger)cellIndex;
- (GameCell *)cellAt:(NSInteger)col;
- (void)hideCells;
- (void)refreshCell:(GameCell *)gameCell at:(NSInteger)col;
- (void)applyDecalage:(NSInteger)x;

@end
