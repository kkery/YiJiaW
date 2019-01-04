//
//  CODBaseBlankView.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/20.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODBaseBlankView.h"

@interface CODBaseBlankView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIView *customView;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, assign) CGFloat verticalSpace;

@end

@implementation CODBaseBlankView

- (void)dealloc {
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - Initialization Methods

- (instancetype)init {
	self =  [super init];
	if (self) {
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(codblk_didTapContentView:)];
        self.tapGesture.delegate = self;
        [self addGestureRecognizer:self.tapGesture];
        
		[self addSubview:self.contentView];
	}
	return self;
}

#pragma mark - Getters

- (UIView *)contentView {
	if (!_contentView) {
		_contentView = [UIView new];
		_contentView.translatesAutoresizingMaskIntoConstraints = NO;
		_contentView.backgroundColor = [UIColor clearColor];
		_contentView.userInteractionEnabled = YES;
	}
	return _contentView;
}

- (UIImageView *)imageView {
	if (!_imageView) {
		_imageView = [UIImageView new];
		_imageView.translatesAutoresizingMaskIntoConstraints = NO;
		_imageView.backgroundColor = [UIColor clearColor];
		_imageView.contentMode = UIViewContentModeScaleAspectFit;
		_imageView.userInteractionEnabled = NO;
		_imageView.accessibilityLabel = @"empty set background image";

		[_contentView addSubview:_imageView];
	}
	return _imageView;
}

- (UILabel *)titleLabel {
	if (!_titleLabel) {
		_titleLabel = [UILabel new];
		_titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
		_titleLabel.backgroundColor = [UIColor clearColor];

		_titleLabel.font = [UIFont systemFontOfSize:17.0];
		_titleLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
		_titleLabel.textAlignment = NSTextAlignmentCenter;
		_titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
		_titleLabel.numberOfLines = 2;
		_titleLabel.accessibilityLabel = @"empty set title";

		[_contentView addSubview:_titleLabel];
	}
	return _titleLabel;
}

- (UILabel *)detailLabel {
	if (!_detailLabel) {
		_detailLabel = [UILabel new];
		_detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
		_detailLabel.backgroundColor = [UIColor clearColor];

		_detailLabel.font = [UIFont systemFontOfSize:17.0];
		_detailLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
		_detailLabel.textAlignment = NSTextAlignmentCenter;
		_detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
		_detailLabel.numberOfLines = 0;
		_detailLabel.accessibilityLabel = @"empty set detail label";

		[_contentView addSubview:_detailLabel];
	}
	return _detailLabel;
}

- (UIButton *)button {
	if (!_button) {
		_button = [UIButton buttonWithType:UIButtonTypeCustom];
		_button.translatesAutoresizingMaskIntoConstraints = NO;
		_button.backgroundColor = [UIColor clearColor];
		_button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		_button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		_button.accessibilityLabel = @"empty set button";

		[_button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];

		[_contentView addSubview:_button];
	}
	return _button;
}

- (BOOL)canShowImage {
	return (_imageView.image && _imageView.superview);
}

- (BOOL)canShowTitle {
	return (_titleLabel.attributedText.string.length > 0 && _titleLabel.superview);
}

- (BOOL)canShowDetail {
	return (_detailLabel.attributedText.string.length > 0 && _detailLabel.superview);
}

- (BOOL)canShowButton {
	return ([_button attributedTitleForState:UIControlStateNormal].string.length > 0 && _button.superview);
}

#pragma mark - Setters

- (void)setCustomView:(UIView *)view {
	if (_customView) {
		[_customView removeFromSuperview];
		_customView = nil;
	}

	if (!view) {
		return;
	}

	_customView = view;
	_customView.translatesAutoresizingMaskIntoConstraints = !CGRectIsEmpty(view.frame);

	[_contentView addSubview:_customView];
}

- (void)setDelegate:(id<CODBaseBlankViewDataDelegate>)delegate {
    if (!delegate) {
        [self codblk_invalidate];
    }
    _delegate = delegate;
}

#pragma mark - Action Methods

- (void)didTapButton:(id)sender {
	SEL selector = NSSelectorFromString(@"codblk_didTapDataButton:");

	if ([self respondsToSelector:selector]) {
		[self performSelector:selector withObject:sender afterDelay:0];
	}
}

- (void)removeAllSubviews {
	[self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

	_titleLabel = nil;
	_detailLabel = nil;
	_imageView = nil;
	_button = nil;
	_customView = nil;
}

- (void)removeAllConstraints {
	[self removeConstraints:self.constraints];
	[self.contentView removeConstraints:self.contentView.constraints];
}

#pragma mark - UIView Constraints & Layout Methods

- (void)updateConstraints {
	// Cleans up any constraints
	[self removeAllConstraints];

	NSMutableDictionary *views = [NSMutableDictionary dictionary];
	[views setObject:self forKey:@"self"];
	[views setObject:self.contentView forKey:@"contentView"];

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[self]-(<=0)-[contentView]"
	                                                             options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[self]-(<=0)-[contentView]"
	                                                             options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];

	if (_customView) {
		[views setObject:_customView forKey:@"customView"];
		[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[customView]|" options:0 metrics:nil views:views]];
		[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[customView]|" options:0 metrics:nil views:views]];

		// Skips from any further configuration
		return [super updateConstraints];
	}

	CGFloat width = CGRectGetWidth(self.frame) ? : CGRectGetWidth([UIScreen mainScreen].bounds);
	NSNumber *padding =  [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? @20 : @(roundf(width / 16.0));
	NSNumber *imgWidth = @(roundf(_imageView.image.size.width));
	NSNumber *imgHeight = @(roundf(_imageView.image.size.height));
	NSNumber *trailing = @(roundf((width - [imgWidth floatValue]) / 2.0));

	NSDictionary *metrics = NSDictionaryOfVariableBindings(padding, trailing, imgWidth, imgHeight);

	// Since any element could be missing from displaying, we need to create a dynamic string format
	NSMutableArray *verticalSubviews = [NSMutableArray new];

	// Assign the image view's horizontal constraints
	if (_imageView.superview) {
		[views setObject:_imageView forKey:@"imageView"];
		[verticalSubviews addObject:@"[imageView(imgHeight)]"];

		[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-trailing-[imageView(imgWidth)]-trailing-|"
		                                                                         options:0 metrics:metrics views:views]];
	}

	// Assign the title label's horizontal constraints
	if ([self canShowTitle]) {
		[views setObject:_titleLabel forKey:@"titleLabel"];
		[verticalSubviews addObject:@"[titleLabel]"];

		[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[titleLabel]-padding-|"
		                                                                         options:0 metrics:metrics views:views]];
	}
	// or removes from its superview
	else {
		[_titleLabel removeFromSuperview];
		_titleLabel = nil;
	}

	// Assign the detail label's horizontal constraints
	if ([self canShowDetail]) {
		[views setObject:_detailLabel forKey:@"detailLabel"];
		[verticalSubviews addObject:@"[detailLabel]"];

		[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[detailLabel]-padding-|"
		                                                                         options:0 metrics:metrics views:views]];
	}
	// or removes from its superview
	else {
		[_detailLabel removeFromSuperview];
		_detailLabel = nil;
	}

	// Assign the button's horizontal constraints
	if ([self canShowButton]) {
		[views setObject:_button forKey:@"button"];
		[verticalSubviews addObject:@"[button]"];

		[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[button]-padding-|"
		                                                                         options:0 metrics:metrics views:views]];
	}
	// or removes from its superview
	else {
		[_button removeFromSuperview];
		_button = nil;
	}
    
    // Build the string format for the vertical constraints, adding a margin between each element. Default is 12.
    NSString *verticalFormat = [verticalSubviews componentsJoinedByString:[NSString stringWithFormat:@"-%.f-", self.verticalSpace ?: 12]];
    
    // Assign the vertical constraints to the content view
    if (verticalFormat.length > 0) {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|%@|", verticalFormat]
                                                                                 options:0 metrics:metrics views:views]];
    }

	[super updateConstraints];
}

#pragma mark - Reload blank view
- (void)reloadBlankView {
	if ([self codblk_shouldDisplay]) {
		// Notifies that the empty dataset view will appear
		[self codblk_willWillAppear];

		CODBaseBlankView *view = self;
        [view setUserInteractionEnabled:[self codblk_isTouchAllowed]];
        
		UIView *customView = [self codblk_customView];

		// Moves all its subviews
		[view removeAllSubviews];

		// If a non-nil custom view is available, let's configure it instead
		if (customView) {
			view.customView = customView;
		}
		else {
			// Configure labels
			view.detailLabel.attributedText = [self codblk_detailLabelText];
			view.titleLabel.attributedText = [self codblk_titleLabelText];

			// Configure imageview
			view.imageView.image = [self codblk_image];

			// Configure button
			[view.button setAttributedTitle:[self codblk_buttonTitleForState:0] forState:0];
			[view.button setAttributedTitle:[self codblk_buttonTitleForState:1] forState:1];
			[view.button setBackgroundImage:[self codblk_buttonBackgroundImageForState:0] forState:0];
			[view.button setBackgroundImage:[self codblk_buttonBackgroundImageForState:1] forState:1];
			[view.button setUserInteractionEnabled:[self codblk_isTouchAllowed]];
            
            // Configure spacing
            view.verticalSpace = [self codblk_verticalSpace];
		}

		// Configure the empty dataset view
		view.backgroundColor = [self codblk_dataSetBackgroundColor];
		view.hidden = NO;

		[view updateConstraints];
		[view layoutIfNeeded];
	}
	else {
		[self codblk_invalidate];
	}
}

#pragma mark - Private methods
- (void)codblk_invalidate {
	// Notifies that the empty dataset view will disappear
	[self codblk_willDisappear];

    [self removeAllSubviews];
    [self removeFromSuperview];
}

#pragma mark - Data Source Getters

- (NSAttributedString *)codblk_titleLabelText {
	if (self.dataSource && [self.dataSource respondsToSelector:@selector(titleForBlankView:)]) {
		NSAttributedString *string = [self.dataSource titleForBlankView:self];
		if (string) NSAssert([string isKindOfClass:[NSAttributedString class]], @"You must return a valid NSAttributedString object -titleForBlankView:");
		return string;
	}
	return nil;
}

- (NSAttributedString *)codblk_detailLabelText {
	if (self.dataSource && [self.dataSource respondsToSelector:@selector(descriptionForBlankView:)]) {
		NSAttributedString *string = [self.dataSource descriptionForBlankView:self];
		if (string) NSAssert([string isKindOfClass:[NSAttributedString class]], @"You must return a valid NSAttributedString object -descriptionForBlankView:");
		return string;
	}
	return nil;
}

- (UIImage *)codblk_image {
	if (self.dataSource && [self.dataSource respondsToSelector:@selector(imageForBlankView:)]) {
		UIImage *image = [self.dataSource imageForBlankView:self];
		if (image) NSAssert([image isKindOfClass:[UIImage class]], @"You must return a valid UIImage object for -imageForBlankView:");
		return image;
	}
	return nil;
}

- (NSAttributedString *)codblk_buttonTitleForState:(UIControlState)state {
	if (self.dataSource && [self.dataSource respondsToSelector:@selector(buttonTitleForBlankView:forState:)]) {
		NSAttributedString *string = [self.dataSource buttonTitleForBlankView:self forState:state];
		if (string) NSAssert([string isKindOfClass:[NSAttributedString class]], @"You must return a valid NSAttributedString object for -buttonTitleForBlankView:forState:");
		return string;
	}
	return nil;
}

- (UIImage *)codblk_buttonBackgroundImageForState:(UIControlState)state {
	if (self.dataSource && [self.dataSource respondsToSelector:@selector(buttonBackgroundImageForBlankView:forState:)]) {
		UIImage *image = [self.dataSource buttonBackgroundImageForBlankView:self forState:state];
		if (image) NSAssert([image isKindOfClass:[UIImage class]], @"You must return a valid UIImage object for -buttonBackgroundImageForBlankView:forState:");
		return image;
	}
	return nil;
}

- (UIColor *)codblk_dataSetBackgroundColor {
	if (self.dataSource && [self.dataSource respondsToSelector:@selector(backgroundColorForBlankView:)]) {
		UIColor *color = [self.dataSource backgroundColorForBlankView:self];
		if (color) NSAssert([color isKindOfClass:[UIColor class]], @"You must return a valid UIColor object -backgroundColorForBlankView:");
		return color;
	}
	return [UIColor clearColor];
}

- (UIView *)codblk_customView {
	if (self.dataSource && [self.dataSource respondsToSelector:@selector(customViewForBlankView:)]) {
		UIView *view = [self.dataSource customViewForBlankView:self];
		if (view) NSAssert([view isKindOfClass:[UIView class]], @"You must return a valid UIView object for -customViewForBlankView:");
		return view;
	}
	return nil;
}

- (CGFloat)codblk_verticalSpace
{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(spaceHeightForBlankView:)]) {
        return [self.dataSource spaceHeightForBlankView:self];
    }
    return 0;
}

#pragma mark - Delegate Getters & Events

- (BOOL)codblk_shouldDisplay {
	if (self.delegate && [self.delegate respondsToSelector:@selector(blankViewShouldDisplay:)]) {
		return [self.delegate blankViewShouldDisplay:self];
	}
	return YES;
}

- (BOOL)codblk_isTouchAllowed {
	if (self.delegate && [self.delegate respondsToSelector:@selector(blankViewShouldAllowTouch:)]) {
		return [self.delegate blankViewShouldAllowTouch:self];
	}
	return YES;
}

- (void)codblk_willWillAppear {
	if (self.delegate && [self.delegate respondsToSelector:@selector(blankViewWillAppear:)]) {
		[self.delegate blankViewWillAppear:self];
	}
}

- (void)codblk_willDisappear {
	if (self.delegate && [self.delegate respondsToSelector:@selector(blankViewWillDisappear:)]) {
		[self.delegate blankViewWillDisappear:self];
	}
}

- (void)codblk_didTapContentView:(id)sender {
	if (self.delegate && [self.delegate respondsToSelector:@selector(blankViewDidTapView:)]) {
		[self.delegate blankViewDidTapView:self];
	}
}

- (void)codblk_didTapDataButton:(id)sender {
	if (self.delegate && [self.delegate respondsToSelector:@selector(blankViewDidTapButton:)]) {
		[self.delegate blankViewDidTapButton:self];
	}
}

#pragma mark - UIGestureRecognizerDelegate Methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer.view isEqual:self]) {
        return [self codblk_isTouchAllowed];
    }
    
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    UIGestureRecognizer *tapGesture = self.tapGesture;
    
    if ([gestureRecognizer isEqual:tapGesture] || [otherGestureRecognizer isEqual:tapGesture]) {
        return YES;
    }
    
    // defer to blankView delegate's implementation if available
    if ([self.delegate respondsToSelector:@selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)]) {
        return [(id)self.delegate gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    }
    
    return NO;
}

@end
