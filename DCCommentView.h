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

@optional
/**
 the comment view presented.
 */
-(void)didShowCommentView;

/**
 the comment view was dismissed/pulled down
 */
-(void)didDismissCommentView;

/**
 The user started typing
 */
-(void)didStartTypingComment;

/**
 The user cleared the text and stop typing
 */
-(void)didStopTypingComment;

@end

@interface DCCommentView : UIView

/**
 the comment view delegate.
 */
@property(nonatomic,weak)id<DCCommentViewDelegate>delegate;

/**
 limit the amount of characters that can be sent. Default is 0, which is unlimited.
 */
@property(nonatomic,assign)NSInteger charLimit;

/**
 add an image for your accessory button (e.g. the camera icon in the messages app).
 default is nil and no image will be displayed.
 */
@property(nonatomic,strong)UIImage *accessoryImage;

/**
 Create a new commentView with the scrollview you want to add as its child view 
 and the frame of the overall commentView (normally this is self.view.bounds).
 @param scrollView is the scrollView to add as a subview of commentView and is in charge of displaying your content. 
 This could be a tableView or collectionView since the both subclass scrollView
 @param frame is the same frame you would pass to initWithFrame:. This is the frame of the whole view (normally this is self.view.bounds).
 @return a newly initialized comment view.
 */
-(instancetype)initWithScrollView:(UIScrollView*)scrollView frame:(CGRect)frame;

@end
