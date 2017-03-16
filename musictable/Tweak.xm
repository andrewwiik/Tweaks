#import <UIKit/UIKit.h> // We need to Import UJIKIt
#import <CoreGraphics/CoreGraphics.h> // We need to Also Import the CoreGraphics Framework
#import <QuartzCore/QuartzCore.h> // and the QuartzCore Framework
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"
@interface MusicTableViewDelegate <UITableViewDelegate>
@end
@interface MusicBasicTableView : UITableView
@end
@interface MusicTableView : MusicBasicTableView
@end
@interface MusicLibraryBrowseTableViewController : MusicTableViewDelegate
@property (nonatomic, readonly) MusicTableView *tableView;
@end
@interface MusicEntityHorizontalLockupTableViewCell : UITableViewCell
@end

%hook MusicLibraryBrowseTableViewController
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * reuseIdentifier = @"programmaticCell";
    MGSwipeTableCell * cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[MGSwipeTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }

    cell.textLabel.text = @"Test";
    cell.detailTextLabel.text = @"test2";


    //configure left buttons
    cell.leftButtons = @[[MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"check.png"] backgroundColor:[UIColor greenColor]],
                          [MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"fav.png"] backgroundColor:[UIColor blueColor]]];
    cell.leftSwipeSettings.transition = MGSwipeTransition3D;

    //configure right buttons
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor]],
                           [MGSwipeButton buttonWithTitle:@"More" backgroundColor:[UIColor lightGrayColor]]];
    cell.rightSwipeSettings.transition = MGSwipeTransition3D;
    return cell;
}
%end