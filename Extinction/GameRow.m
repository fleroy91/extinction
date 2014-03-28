//
//  GameRow.m
//  ToDoList
//
//  Created by Frédéric Leroy on 06/03/2014.
//  Copyright (c) 2014 Frédéric Leroy. All rights reserved.
//

#import "GameRow.h"

@implementation GameRow
- (id)init
{
    self = [super init];
    if (self) {
        self.cells = [[NSMutableArray alloc] init];
        self.decalCellX = 0;
    }
    return self;
}
- (GameCell *)cellAt:(NSInteger)col
{
    return self.cells[(col + self.decalCellX + [self.cells count]) % [self.cells count]];
}

- (NSInteger)changeKindForRandomCell:(enum CELL_KIND)cell_kind {
    NSInteger colChanged;
    while(true) {
        int place_index = rand() % [self.cells count];
        GameCell *cell = [self.cells objectAtIndex:place_index];
        if(cell.kind == none) {
            cell.kind = cell_kind;
            colChanged = place_index;
            break;
        }
    }
    return colChanged;
}

- (void)changeCellForRandomKind:(NSInteger)cellIndex {
    enum CELL_KIND kind = rand() % ([GameCell nbKindsForCells] - 1) + 1;
    GameCell *cell = [self.cells objectAtIndex:cellIndex];
    cell.kind = kind;
}

- (void)applyDecalage:(NSInteger)x
{
    NSMutableArray *newCells = [[NSMutableArray alloc] init];
    for(int i = 0; i< [self.cells count]; i++) {
        int indexCell = (i + x) % [self.cells count];
        [newCells addObject:self.cells[indexCell]];
    }
    self.cells = newCells;
}

- (void)hideCells
{
    for(int i =0; i < [self.view.subviews count]; i++) {
        UIView *subView = self.view.subviews[i];
        if(! subView.hidden && subView.alpha > 0.0) {
            [subView setAlpha:0.2];
        }
    }
}

- (void)refreshCell:(GameCell *)cell at:(NSInteger)col
{
    for(int t = 0; t < 3; t++) {
        int index = t * [self.cells count] + (col + self.decalCellX + [self.cells count]) % [self.cells count];
        UIImageView *subView = self.view.subviews[index];
        // NSLog(@"Refreshing %d,%d %f ", self.rowIndex, index, [subView frame].origin.x);
        if(! subView.hidden && subView.alpha > 0.0) {
            [subView setAlpha:0.7];
            [subView setImage:[cell getImage]];
        }
    }
}

@end
