////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DCCommentView.h
//
//  Created by Dalton Cherry on 3/10/14.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

#import <UIKit/UIKit.h>

@protocol DCCommentViewDelegate <NSObject>

/**
 the send button was tapped.
 @param the text that was entered in the comment view.
 */
-(void)didSendComment:(NSString*)text;

@end

@interface DCCommentView : UIView

/**
 the comment view delegate.
 */
@property(nonatomic,weak)id<DCCommentViewDelegate>delegate;

/**
 add an image for your accessory button (e.g. the camera icon in the messages app).
 default is nil and no image will be displayed.
 */
@property(nonatomic,strong)UIImage *accessoryImage;

/**
 binds the comment view to the scrollView (this is with the comment view at the bottom of the view
 and selectable to bring up the keyboard). The scrollView must have a superview for this work properly.
 @param scrollView is the a scrollView or scrollView subclass (like a UITableView).
 @param the view to add the commentview as a subview too. 
 @return returns a newly initialized comment view.
 */
-(void)bindToScrollView:(UIScrollView*)scrollView superview:(UIView*)superview;

@end
