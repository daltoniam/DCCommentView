////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DCCommentView.m
//
//  Created by Dalton Cherry on 3/10/14.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

#import "DCCommentView.h"

@interface DCCommentView ()

@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,assign)BOOL isFixed;
@property(nonatomic,assign)CGRect lastRect;
@property(nonatomic,weak)UIView *lastSuperview;
@property(nonatomic,strong)UIButton *sendButton;
@property(nonatomic,assign)float normalHeight;
@property(nonatomic,assign)float oldSize;
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UIToolbar *blurBar;
@property(nonatomic,strong)UILabel *textLabel;
@property(nonatomic,strong)UIButton *accessoryButton;
@property(nonatomic,assign)BOOL lastKeyboard;
@property(nonatomic,weak)UIScrollView *scrollView;

@end

@implementation DCCommentView

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIColor *color = self.tintColor;
        if(!color)
            color = [UIColor blueColor];
        self.backgroundColor = [UIColor clearColor];
        self.blurBar = [[UIToolbar alloc] init];
        self.blurBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.blurBar];
        
        self.normalHeight = 48;
        self.backView = [[UIView alloc] init];
        self.backView.backgroundColor = [UIColor whiteColor];
        self.backView.layer.cornerRadius = 8;
        self.backView.layer.borderWidth = 1;
        self.backView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        [self addSubview:self.backView];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.text = NSLocalizedString(@"Message", nil);
        self.textLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1];
        [self.backView addSubview:self.textLabel];
        
        self.textView = [[UITextView alloc] init];
        self.textView.tintColor = color;
        self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.textView.bounces = NO;
        self.textView.delegate = (id<UITextViewDelegate>)self;
        self.textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        self.textView.backgroundColor = [UIColor clearColor];
        [self.backView addSubview:self.textView];
        self.textView.inputAccessoryView = self;
        [self.textView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidShow:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidHide:)
                                                     name:UIKeyboardDidHideNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];//[FTButton buttonWithColor:[UIColor CSHighlightColor] raised:NO];
        [self.sendButton setTitleColor:color forState:UIControlStateNormal];
        [self.sendButton setTitleColor:[UIColor colorWithWhite:0.7 alpha:0.5] forState:UIControlStateDisabled];
        [self.sendButton setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
        self.sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        self.sendButton.enabled = NO;
        [self.sendButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.sendButton];
        
    }
    return self;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    NSLog(@"frame origin: %f",frame.origin.y);
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.blurBar.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    float pad = 8;
    float btnWidth = 50;
    float left = pad;
    float tpad = 2;
    if(self.accessoryImage)
    {
        float imgWidth = 30;
        self.accessoryButton.frame = CGRectMake(pad/2, 0, imgWidth+pad, self.frame.size.height);
        left += self.accessoryButton.frame.size.width;
    }
    self.backView.frame = CGRectMake(left, pad, self.frame.size.width-(left+btnWidth+pad), self.frame.size.height-(pad*2));
    self.textView.frame = CGRectMake(tpad, 0, self.backView.frame.size.width-(tpad*2), self.backView.frame.size.height);
    self.textLabel.frame = CGRectMake(pad, 0, self.backView.frame.size.width-(pad*2), self.backView.frame.size.height);
    left += self.backView.frame.size.width + (pad/2);
    self.sendButton.frame = CGRectMake(left, pad, btnWidth, self.frame.size.height-(pad*2));
    self.oldSize = self.textView.contentSize.height;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    if(tintColor)
    {
        self.textView.tintColor = tintColor;
        [self.sendButton setTitleColor:tintColor forState:UIControlStateNormal];
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)setAccessoryImage:(UIImage *)accessoryImage
{
    _accessoryImage = accessoryImage;
    if(accessoryImage)
    {
        self.accessoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.accessoryButton setImage:accessoryImage forState:UIControlStateNormal];
        self.accessoryButton.showsTouchWhenHighlighted = YES;
        //self.accessoryButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.accessoryButton];
    }
    else
    {
        [self.accessoryButton removeFromSuperview];
        self.accessoryButton = nil;
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)sendMessage
{
    [self.delegate didSendComment:self.textView.text];
    self.textView.text = @"";
    [self textState:@""];
    [self setNeedsDisplay];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([self.delegate respondsToSelector:@selector(didShowCommentView)])
        [self.delegate didShowCommentView];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if([self.delegate respondsToSelector:@selector(didDismissCommentView)])
        [self.delegate didDismissCommentView];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textViewDidChange:(UITextView *)txtView
{
    [self textState:txtView.text];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)textState:(NSString*)text
{
    if(text.length > 0)
    {
        self.sendButton.enabled = YES;
        self.textLabel.hidden = YES;
    }
    else
    {
        self.sendButton.enabled = NO;
        self.textLabel.hidden = NO;
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([object isKindOfClass:[UITextView class]])
    {
        UITextView *tv = object;
        float hLimit = 90;
        float yOffset = 0;
        if(self.oldSize > tv.contentSize.height)
            yOffset += self.oldSize - tv.contentSize.height;
        else if([tv.text characterAtIndex:tv.text.length-1] == '\n') //this is to work around yet another bug in input accessory.
            yOffset -= tv.font.pointSize+5;
        if(tv.contentSize.height < hLimit)
        {
            CGRect frame = self.frame;
            frame.size.height = tv.contentSize.height+10;
            frame.origin.y += yOffset;
            self.frame = frame;
            [self.superview setNeedsLayout];
        }
        CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
        if(yOffset > 0)
            topCorrect = self.textView.font.pointSize-topCorrect;
        tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
    }
    else if(self.isFixed)
    {
        UIView *view = object;
        //NSLog(@"view: %@",view);
        [UIView animateWithDuration:0.15 animations:^{
            CGRect frame = self.scrollView.frame;
            frame.size.height = view.frame.origin.y;
            self.scrollView.frame = frame;
        }];
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)bindToScrollView:(UIScrollView*)scrollView superview:(UIView*)superview
{
    if(self.superview != superview)
    {
        self.scrollView = scrollView;
        scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
        float height = self.normalHeight;
        self.frame = CGRectMake(0, superview.frame.size.height-height, superview.frame.size.width, height);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        CGRect frame = scrollView.frame;
        frame.size.height -= height;
        scrollView.frame = frame;
        [superview addSubview:self];
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (self.superview)
    {
        [self.superview removeObserver:self
                            forKeyPath:@"frame"];
    }
    
    [newSuperview addObserver:self
                   forKeyPath:@"frame"
                      options:0
                      context:NULL];
    
    [super willMoveToSuperview:newSuperview];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma keyboard handling
////////////////////////////////////////////////////////////////////////////////////////////////////
-(BOOL)isFirstResponder
{
    return [self.textView isFirstResponder];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(BOOL)becomeFirstResponder
{
    return [self.textView becomeFirstResponder];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(BOOL)resignFirstResponder
{
    return [self.textView resignFirstResponder];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
//this is a hack to work around a bug in the input accessory view.
-(void)firstUpdate
{
    self.isFixed = YES;
    [self.textView becomeFirstResponder];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) moveTextViewForKeyboard:(NSNotification*)aNotification up:(BOOL)up
{
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration = 0;
    
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    //if(up == self.lastKeyboard)
    //    return;
    //self.lastKeyboard = up;
    if(animationDuration != 0)
    {
        //NSLog(@"keyboard moved to: %@", up ? @"UP" : @"NO");
        if(!self.isFixed && up)
        {
            self.lastRect = self.frame;
            self.lastSuperview = self.superview;
            [self performSelector:@selector(firstUpdate) withObject:nil afterDelay:0.01];
            return;
        }
        else if(!up)
        {
            self.isFixed = NO;
            [self removeFromSuperview];
            [self.lastSuperview addSubview:self];
            self.frame = self.lastRect;
        }
        
    }
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    if(self.scrollView.superview)
        keyboardFrame = [self.scrollView.superview convertRect:keyboardFrame toView:nil];
    float height = keyboardFrame.size.height;
    
    [UIView beginAnimations:nil context:nil];
    if(up)
        [UIView setAnimationDuration:0.2];
    else
        [UIView setAnimationDuration:0.3];
    CGRect frame = self.scrollView.frame;
    if(up)
        frame.size.height = self.scrollView.superview.frame.size.height - height;
    else
        frame.size.height = self.scrollView.superview.frame.size.height - self.frame.size.height;
    self.scrollView.frame = frame;
    [UIView commitAnimations];
    
    if(animationDuration != 0)
    {
        if(up)
        {
            [self.scrollView scrollRectToVisible:CGRectMake(0.0,
                                                            self.scrollView.contentSize.height - 1.0,
                                                            1.0,
                                                            1.0)
                                        animated:YES];
        }
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)keyboardDidShow:(NSNotification *)aNotification
{
    [self moveTextViewForKeyboard:aNotification up:YES];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)keyboardDidHide:(NSNotification *)aNotification
{
    [self moveTextViewForKeyboard:aNotification up:NO];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    //NSLog(@"will hide: %@",aNotification);
    //[self moveTextViewForKeyboard:aNotification up:NO];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)dealloc
{
    if (self.superview)
    {
        [self.superview removeObserver:self
                            forKeyPath:@"frame"];
    }
    [self.textView removeObserver:self forKeyPath:@"contentSize"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
////////////////////////////////////////////////////////////////////////////////////////////////////

@end
