DCCommentView
=============

Comment view for iOS, same as messages app. Customizable.

![alt tag](https://raw.github.com/daltoniam/DCCommentView/master/demo.gif)

#Example

```objective-c
@interface CommentsViewController ()

@property(nonatomic,strong)DCCommentView *commentView;

@end
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.commentView = [[DCCommentView alloc] initWithScrollView:self.tableView frame:self.view.bounds];
    self.commentView.delegate = self;
    [self.view addSubview:self.commentView];
    //self.commentView.charLimit = 255; you can set this if you want a character limit
    self.commentView.tintColor = [UIColor redColor]; //sets the proper accent items to red
    //self.commentView.accessoryImage = [UIImage imageNamed:@"someimage"]; where the camera button would go
	//more setup code
}
```

# Install #

The recommended approach for installing DCCommentView is via the CocoaPods package manager, as it provides flexible dependency management and dead simple installation.

via CocoaPods

Install CocoaPods if not already available:

	$ [sudo] gem install cocoapods
	$ pod setup
Change to the directory of your Xcode project, and Create and Edit your Podfile and add DCCommentView:

	$ cd /path/to/MyProject
	$ touch Podfile
	$ edit Podfile
	platform :ios, '7.0'
	pod 'DCCommentView'

Install into your project:

	$ pod install

Open your project in Xcode from the .xcworkspace file (not the usual project file)

Via git
just add DCCommentView as a git submodule

# Requirements #

DCCommentView requires at least iOS 7.

# License #

DCCommentView is license under the Apache License.

# Contact #

### Dalton Cherry ###
* https://github.com/daltoniam
* http://twitter.com/daltoniam
