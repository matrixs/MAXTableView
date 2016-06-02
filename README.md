# MAXTableView

MAXTableView is an extension for UITableView and UITableViewCell. It's aimed to calculate cells' height which are layout based on AutoLayout automatically for you. 
It caches cell height during calculation process for optimization, and making it work is very easy.

## Installation

MAXTableView is available on [CocoaPods](https://cocoapods.org). Just add the following to you project Podfile:

```ruby
pod 'MAXTableView', '~>0.0.5'
```

Bugs are first fixed in master and then made available via a designated release. If you tend to live on the bleeding edge, you can use Pop from 
master with the following Podfile entry:

```ruby
pod 'MAXTableView', :git=>'https://github.com/matrixs/MAXTableView.git'
```

## Usage

Use by including the follwing import:

```objective-c
#import "UITableView+MAXTableView.h"
```

```objective-c
NSMutableArray *data = [NSMutableArray new];
[yourTableView registerClass:[YourCustomCell class] bindDataSource:data delegate:self];
... //data manipulation
[yourTableView reloadData];
```
And then in YourCustomCell class, you need implement below method:

```objective-c
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    ...// Use autolayout to layout your content
}
-(void)fillData:(id)data {
	...// set data to your UIKit elements' property
}
```
## Contributing
See the CONTRIBUTING file for how to help out.

## License

Pop is released under a GNU License. See LICENSE file for details.