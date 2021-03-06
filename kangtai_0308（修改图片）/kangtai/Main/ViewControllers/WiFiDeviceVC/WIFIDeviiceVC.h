//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "MainVC.h"
#import "DeviceManager.h"
#import "SingleVC.h"
#import "WIFIDeviceCell.h"
#import "AddDeviceVC.h"
#import "DragSortView.h"
#import "EditableTableController.h"

enum{
    ohBuyRightMove = 1,
    ohBuyResetMove,
};

@protocol ohBuyMoveDelegate <NSObject>

- (void)ohBuyMoveMethod:(NSInteger)index;

@end

@interface WIFIDeviiceVC :MainVC <UITableViewDataSource, UITableViewDelegate, EditableTableControllerDelegate>
{
    UITableViewCellEditingStyle _editingStyle;
}

@property (strong,nonatomic) Device * device;
@property (nonatomic, assign) id <ohBuyMoveDelegate> delegate;
@property (nonatomic, assign) BOOL disconnect;

@end
