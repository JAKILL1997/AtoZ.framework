
#import "AtoZGridView.h"
//#import <DrawKit/DKDrawKit.h>

//#import <DrawKit/DKStrokeDash.h>


NSString *const reuseIdentifier = @"AtoZGridViewItem";

//static CGFloat kDefaultContentInset;
//static CGFloat kDefaultSelectionRingLineWidth;
//static CGFloat kDefaultItemBorderRadius;

#pragma mark CNSelectionFrameView
@interface CNSelectionFrameView : NSView
@end

const int CNSingleClick	 	= 1;
const int CNDoubleClick 	= 2;
const int CNTrippleClick	= 3;

struct CNItemPoint {	NSUI column;	NSUI row;	};

typedef struct CNItemPoint CNItemPoint;

CNItemPoint CNMakeItemPoint(NSUI aColumn, NSUI aRow) {
	CNItemPoint point;
	point.column = aColumn;
	point.row = aRow;
	return point;
}

@interface AZGView ()

@property (strong) NSMD 	*keyedVisibleItems, *reuseableItems, *selectedItems, *selectedItemsBySelectionFrame;
@property (strong) NSTA 	*gridViewTrackingArea;
@property (strong) NSMA 	*clickEvents;
@property (strong) NSTimer 	*clickTimer;

@property (strong) CNSelectionFrameView *selectionFrameView;

@property (assign) CGP 	selectionFrameInitialPoint;
@property (assign) BOOL isInitialCall, 		abortSelection;
@property (assign) NSI 	lastHoveredIndex, 	lastSelectedIndex,	numberOfItems;

- (void)  setupDefaults;
- (void)  updateVisibleRect;
- (void)  updateReuseableItems;
- (void)  updateVisibleItems;
- (NSIS*) indexesForVisibleItems;
- (void)  refreshGridViewAnimated:		(BOOL)animated;
- (void)  arrangeGridViewItemsAnimated:	(BOOL)animated;
- (NSR)   rectForItemAtIndex:		(NSUI)index;
- (NSUI)  indexForItemAtLocation:	(NSP)location;
- (NSRNG) currentRange;
- (NSUI)  columnsInGridView;
- (NSUI)  allOverRowsInGridView;
- (NSUI)  visibleRowsInGridView;
- (NSR)   clippedRect;

- (CNItemPoint) locationForItemAtIndex:(NSUI)itemIndex;
- (void) selectItemAtIndex:(NSUI)selectedItemIndex usingModifierFlags:(NSUI)modifierFlags;
- (void) handleClicks:(NSTimer*) theTimer;
- (void) handleSingleClickForItemAtIndex:(NSUI)selectedItemIndex;
- (void) handleDoubleClickForItemAtIndex:(NSUI)selectedItemIndex;
- (void) drawSelectionFrameForMousePointerAtLocation:(NSPoint)location;
- (void) selectItemsCoveredBySelectionFrame:(NSRect)selectionFrame usingModifierFlags:(NSUI)modifierFlags;
@end

@class AtoZGridViewItem;
@implementation AtoZGridView
{
	CIImage *inputMaskImage, *inputShadingImage;
}

//+ (void)initialize
//{
//	kDefaultSelectionRingLineWidth = 12.0f;
//	kDefaultContentInset = 7.0f;
//	kDefaultItemBorderRadius = 10.0f;
//}

#pragma mark - Initialization
- (id)init
{
	if (self != super.init ) return nil;
	[self setupDefaults];
	_delegate 	= nil;
	_dataSource = nil;
	return self;
}

- (id)initWithFrame:(NSRect)frame
{
	if (self != [super initWithFrame:frame]) return nil;
	[self setupDefaults];
	_delegate 	= nil;
	_dataSource = nil;
	return self;
}

- (id)initWithCoder:(NSCoder*) aDecoder
{
	if (!(self = [super initWithCoder:aDecoder])) return nil;
	[self setupDefaults];
	return self;
}

- (void) setupDefaults
{

//	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
//	// preload shading bitmap to use in transitions:
//	// this one is for "SlideshowViewPageCurlTransitionStyle", and "SlideshowViewRippleTransitionStyle"
//	NSURL *pathURL = [NSURL fileURLWithPath:[bundle pathForResource:@"restrictedshine" ofType:@"tiff"]];
//	inputShadingImage = [CIImage imageWithContentsOfURL:pathURL];
//	// this one is for "SlideshowViewDisintegrateWithMaskTransitionStyle"
//	pathURL = [NSURL fileURLWithPath:[bundle pathForResource:@"transitionmask" ofType:@"jpg"]];
//	inputMaskImage = [CIImage imageWithContentsOfURL:pathURL];

	_visibleContentMask	 = (AtoZGridViewItemVisibleContentImage | AtoZGridViewItemVisibleContentTitle);
	/// title text font attributes
	NSShadow *textShadow		= NSShadow.new;
	textShadow.shadowColor		= self.itemTitleShadowColor;
	textShadow.shadowBlurRadius	= 2;
	textShadow.shadowOffset		= NSMakeSize(.5, -1);
	NSMutableParagraphStyle *textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
	textStyle.alignment	 		= NSCenterTextAlignment;
	_itemTitleTextAttributes	= @{	NSFontAttributeName			  	: [AtoZ font:@"Ubuntu" size:16],
										NSShadowAttributeName			: textShadow,
										NSForegroundColorAttributeName	: self.itemTitleColor,
										NSParagraphStyleAttributeName	: textStyle};

	//	CATiledLayer *laya = [CATiledLayer layer];
	//	laya.frame = self.window.frame;
	//	laya.backgroundColor = [[NSC greenColor]CGColor];
	//	self.enclosingScrollView.layer = laya;
	//	self.enclosingScrollView.wantsLayer = YES;

	/// private properties
	_keyedVisibleItems	= [NSMD new]; _reuseableItems = [NSMD new]; _selectedItems = [NSMD new]; _selectedItemsBySelectionFrame	= [NSMD new];
	/// public properties
	_gridViewTitle 		= nil;
	_itemSize 			= (NSSZ) {96,96};// [AZGVItem defaultItemSize];
	_allowsMultipleSelection = NO;
	_useSelectionRing 	= _allowsSelection   = 	_scrollElasticity =  _useHover = _isInitialCall = YES;
	_lastHoveredIndex 	= _lastSelectedIndex = NSNotFound;
	_clickEvents 		= NSMA.new;
	_clickTimer 		= nil;
	_selectionFrameView = nil;
	_selectionFrameInitialPoint = CGPointZero;
	_abortSelection 	= NO;

	//	[self updateSubviewsWithTransition:@"CIRippleTransition"];
	//	self.enclosingScrollView.drawsBackground 	= YES;
	//	self.enclosingScrollView.backgroundColor = [NSC redColor];
//	NSClipView *clipView 						= self.enclosingScrollView.contentView;
//	clipView.postsBoundsChangedNotifications	= YES;
//	[AZNOTCENTER addObserver:self selector:@selector(updateVisibleRect) name:NSViewBoundsDidChangeNotification object:clipView];
}

//- (void) awakeFromNib
//{
//	self.enclosingScrollView.drawsBackground 	= NO;
////	self.enclosingScrollView.backgroundColor = [NSC redColor];
//}

#pragma mark - Accessors
- (void) setItemSize:(NSSize)itemSize
{
	_itemSize = itemSize;
	_selectionRingLineWidth =  _itemBorderRadius = .05 * _itemSize.width;//kDefaultSelectionRingLineWidth;
	_contentInset		   	= 						.1 * _itemSize.width;//kDefaultContentInset;   //kDefaultItemBorderRadius;
	[self refreshGridViewAnimated:YES];
}
- (void) setScrollElasticity:(BOOL)scrollElasticity
{
	NSScrollElasticity i = scrollElasticity  ? NSScrollElasticityAllowed : NSScrollElasticityNone;
	[[self enclosingScrollView] setHorizontalScrollElasticity:i];
	[[self enclosingScrollView] setVerticalScrollElasticity:  i];
	_scrollElasticity = scrollElasticity;
}

- (void) drawRect:(NSR)dirtyRect { 	NSRectFillWithColor(self.bounds, self.backgroundColor);  }

- (void) setAllowsMultipleSelection:(BOOL)allowsMultipleSelection
{
	_allowsMultipleSelection = allowsMultipleSelection;

	if (self.selectedItems.count > 1 && !allowsMultipleSelection) {
		[self.selectedItems.allKeys each:^(id obj) {
			AZGVItem *item 	= self.selectedItems[obj];
			item.isSelected = NO;
			[self.selectedItems removeObjectForKey:obj];
		}];
		[self updateVisibleRect];
	}
}

#pragma mark - Private Helper
- (void) updateVisibleRect
{
	[self updateReuseableItems]; 	[self updateVisibleItems];		[self arrangeGridViewItemsAnimated:NO];
}

- (void) refreshGridViewAnimated:(BOOL)animated
{
//	NSR scrollRect = [self frame]; scrollRect.size.width = scrollRect.size.width; scrollRect.size.height = [self allOverRowsInGridView] * self.itemSize.height;
	super.frame = AZRectExceptHigh(self.frame, self.allOverRowsInGridView * self.itemSize.height );
	[self updateReuseableItems];	[self updateVisibleItems];	[self arrangeGridViewItemsAnimated:animated];
}

- (void) updateReuseableItems
{
	NSRange currentRange = self.currentRange;
	[self.keyedVisibleItems.allValues eachWithIndex:^(AZGVItem *item, NSInteger idx) {
		if (!NSLocationInRange ( item.index, currentRange ) && item.isReuseable) {
			[self.keyedVisibleItems removeObjectForKey:@(item.index)];
			[item removeFromSuperview];	  	   [item prepareForReuse];
			NSMSet *reuseQueue = self.reuseableItems[item.reuseIdentifier] ?: NSMutableSet.set;
			[reuseQueue addObject:item];
			self.reuseableItems[item.reuseIdentifier] = reuseQueue;
		}
	}];
}
- (void) updateVisibleItems
{
	NSMIS *visibleItemIndexes = [NSMIS indexSetWithIndexesInRange:self.currentRange]; //  NSRange currentRange =
	[visibleItemIndexes removeIndexes:self.indexesForVisibleItems];
	/// update all visible items
	[visibleItemIndexes enumerateIndexesUsingBlock:^(NSUI idx, BOOL *stop) {
		AZGVItem *item = [self gridView:self itemAtIndex:idx inSection:0];
		if (item) {
			item.index = idx;
			if (self.isInitialCall) {
				item.alphaValue	= 0;
				item.frame		= [self rectForItemAtIndex:idx];
			}
			self.keyedVisibleItems[@(item.index)] = item;
			[self.animator addSubview:item];
		}
	}];
}
- (NSIndexSet*) indexesForVisibleItems
{
	__block NSMIS *indexesForVisibleItems = NSMIS.new;
	[self.keyedVisibleItems enumerateKeysAndObjectsUsingBlock:^(id key, AZGVItem* obj, BOOL *stop) {
		[indexesForVisibleItems addIndex:obj.index];
	}];
	return indexesForVisibleItems;
}


- (void)updateSubviewsWithTransition:(NSString *)transition
{
	NSRect		rect = self.bounds;
	CIFilter	*transitionFilter = nil;
	// Use Core Animation's four built-in CATransition types, or an appropriately instantiated and configured Core Image CIFilter.
	transitionFilter = [CIFilter filterWithName:transition];  [transitionFilter setDefaults];
	[transition loMismo:@"CICopyMachineTransition"] ?
	[transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"] :
	[transition loMismo:@"CIDisintegrateWithMaskTransition"] ? ^{
		// scale our mask image to match the transition area size, and set the scaled result as the "inputMaskImage" to the transitionFilter.
		CIFilter *maskScalingFilter = [CIFilter filterWithName:@"CILanczosScaleTransform"]; [maskScalingFilter setDefaults];
		CGRect maskExtent = [inputMaskImage extent];
		float xScale = rect.size.width / maskExtent.size.width;
		float yScale = rect.size.height / maskExtent.size.height;
		[maskScalingFilter setValue:@(yScale) forKey:@"inputScale"];
		[maskScalingFilter setValue:@(xScale / yScale) forKey:@"inputAspectRatio"];
		[maskScalingFilter setValue:inputMaskImage forKey:@"inputImage"];
		[transitionFilter setValue:[maskScalingFilter valueForKey:@"outputImage"] forKey:@"inputMaskImage"]; }() :
	[transition loMismo:@"CIFlashTransition"] ? ^{
		[transitionFilter setValue:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)] forKey:@"inputCenter"];
		[transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"]; }() :
	[transition loMismo:@"CIModTransition"] ?
	[transitionFilter setValue:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)] forKey:@"inputCenter"] :[transition loMismo:@"CIPageCurlTransition"] ? ^{
		[transitionFilter setValue:@(-M_PI_4) forKey:@"inputAngle"];
		[transitionFilter setValue:inputShadingImage forKey:@"inputShadingImage"];
		[transitionFilter setValue:inputShadingImage forKey:@"inputBacksideImage"];
		[transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"]; }() :
	[transition loMismo:@"CIRippleTransition"] ? ^{
		[transitionFilter setValue:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)] forKey:@"inputCenter"];
		[transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"];
		[transitionFilter setValue:inputShadingImage forKey:@"inputShadingImage"];
	}() : nil;
	CATransition *newTransition = [CATransition animation];	// new CATransition that describes the transition
	// we want to build a CIFilter-based CATransition. When an CATransition's "filter" property is set, the CATransition's "type" and "subtype" properties are ignored, so we don't need to bother setting them.   else we want to specify one of Core Animation's built-in transitions.
	transitionFilter ? [newTransition setFilter:transitionFilter] : ^{ [newTransition setType:transition]; [newTransition setSubtype:kCATransitionFromLeft]; }();
	// specify an explicit duration for the transition.
	[newTransition setDuration:1.0];
	// associate the CATransition we've just built with the "subviews" key for this SlideshowView instance,
	// so that when we swap ImageView instances in our -transitionToImage: method below (via -replaceSubview:with:).
	[self setAnimations:@{@"alphaValue": newTransition, @"frame":newTransition}];
}

//+ (id)defaultAnimationForKey:(NSString *)key {
//	if ([key loMismo:@"frame"]) {
//		NSR rect = ;
//		CIFilter* transitionFilter = [CIFilter filterWithName:key];  [transitionFilter setDefaults];
//		[transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"] :
//
//		// By default, animate border color changes with simple linear interpolation to the new color value.
//		return [CABasicAnimation animation];
//	} else {
//		// Defer to super's implementation for any keys we don't specifically handle.
//		return [super defaultAnimationForKey:key];
//	}
//}
//

- (void) arrangeGridViewItemsAnimated:(BOOL)animated
{

	[self updateSubviewsWithTransition:@"CICopyMachineTransition"];
	/// on initial call (aka application startup) we will fade all items (after loading it) in
	if (self.isInitialCall && self.keyedVisibleItems.count > 0) {
		self.isInitialCall = NO;
		animated = YES;
//		[NSAnimationContext beginGrouping];
//		[[NSAnimationContext currentContext] setDuration:(animated ? 1 : 0.0)];
		[NSAnimationContext runAnimationBlock:^{
			[self.keyedVisibleItems enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
				CATransition *animation = [CATransition animation];
				[animation setType:kCATransitionMoveIn];
				[[(AZGVItem*)obj layer] addAnimation:animation forKey:@"isSelected"];
				[[(AZGVItem*) obj animator] setAlphaValue:1.0];
			}];

		} completionHandler:nil duration:animated ? 1 : 0 eased:CAMEDIAEASY];
//		[NSAnimationContext endGrouping];
	}
	else if (_keyedVisibleItems.count > 0)
		[NSAnimationContext runAnimationBlock:^{
			[self.keyedVisibleItems enumerateKeysAndObjectsUsingBlock:^(id key, AZGVItem* obj, BOOL *stop) {
				[obj.animator setFrame:[self rectForItemAtIndex:obj.index]];
			}];
		} completionHandler:nil duration:animated ? 1 : 0 eased:CAMEDIAEASEOUT];
//		NSAnimationContext.currentContext.duration = animated ? 1 : 0;	NSAnimationContext.currentContext.timingFunction = CAMEDIAEASEOUT;
}

- (NSRange)currentRange
{
	NSR clippedRect	= [self clippedRect];
	NSUI columns	= [self columnsInGridView];
	NSUI rows	   = [self visibleRowsInGridView];
	NSUI rangeStart = clippedRect.origin.y > self.itemSize.height
	? (ceilf(clippedRect.origin.y / self.itemSize.height) * columns) - columns : 0;
	NSUI rangeLength = MIN(self.numberOfItems, (columns * rows) + columns);
	rangeLength = ((rangeStart + rangeLength) > self.numberOfItems ? self.numberOfItems - rangeStart : rangeLength);
	NSRange rangeForVisibleRect = NSMakeRange(rangeStart, rangeLength);
	return rangeForVisibleRect;
}
- (NSRect)rectForItemAtIndex:(NSUI)index
{
	NSUI columns = [self columnsInGridView];
 	return NSMakeRect((index % columns) * self.itemSize.width,
					  ((index - (index % columns)) / columns) * self.itemSize.height,
					  self.itemSize.width,
					  self.itemSize.height);

}
- (NSUI)columnsInGridView
{
	NSUI columns = floorf((float)NSWidth([self clippedRect]) / self.itemSize.width);
	return columns < 1 ? 1 : columns;
}

- (NSUI) allOverRowsInGridView	{	return ceilf(self.numberOfItems / self.columnsInGridView);	}

- (NSUI) visibleRowsInGridView	{	return ceilf(NSHeight(self.clippedRect) / self.itemSize.height);	}

- (NSR) clippedRect 			{   return [self.enclosingScrollView.contentView bounds];  }

- (NSUI)  indexForItemAtLocation:(NSP)location
{
	NSP  point = [self convertPoint:location fromView:nil];
	return point.x > (self.itemSize.width * [self columnsInGridView]) ? NSNotFound : ^{
		NSUI currentColumn 	   = floor( point.x / self.itemSize.width  );
		NSUI currentRow 	   = floor( point.y / self.itemSize.height );
		NSUI indexForItemAtLoc = currentRow	* [self columnsInGridView] + currentColumn;
	  return indexForItemAtLoc > self.numberOfItems ? NSNotFound : indexForItemAtLoc;
	}();
}
- (CNItemPoint)locationForItemAtIndex:(NSUI)itemIndex
{
	NSUI columnsInGridView = [self columnsInGridView];
	NSUI row	 		   = floor(itemIndex / columnsInGridView) + 1;
	NSUI column 		   = itemIndex - floor((row -1) * columnsInGridView) + 1;
	return CNMakeItemPoint(column, row);
}

#pragma mark - NSView Methods
- (BOOL) isFlipped { return YES; }

- (void) setFrame:(NSR)frameRect
{
	super.frame = frameRect;
	[self refreshGridViewAnimated: self.frame.size.width != frameRect.size.width ];
	self.enclosingScrollView.needsDisplay = YES;
}
- (void) updateTrackingAreas
{
	if (_gridViewTrackingArea) [self removeTrackingArea:_gridViewTrackingArea];
	self.gridViewTrackingArea = nil;
	self.gridViewTrackingArea =
	[NSTA.alloc initWithRect:self.frame options:NSTrackingMouseMoved | NSTrackingActiveInKeyWindow owner:self userInfo:nil];
	[self addTrackingArea:_gridViewTrackingArea];
}


#pragma mark - Creating GridView Items
- (id)dequeueReusableItemWithIdentifier:(NSString*) identifier
{
	AZGVItem *reusableItem 	= nil;
	NSMSet   *reuseQueue	= self.reuseableItems[identifier];

	if (reuseQueue != nil && reuseQueue.count > 0)
	{
		reusableItem = reuseQueue.anyObject;
		[reuseQueue removeObject:reusableItem];
		self.reuseableItems[identifier] = reuseQueue;
	}
	return reusableItem;
}

#pragma mark - Reloading GridView Data
- (void) reloadData
{
	 self.numberOfItems 				  = [self gridView:self numberOfItemsInSection:0];
	[self.keyedVisibleItems.allValues do:^(AZGVItem *obj) { [obj removeFromSuperview]; }];
	[self.keyedVisibleItems		removeAllObjects];
	[self.reuseableItems		removeAllObjects];
	[self refreshGridViewAnimated:YES];
}

#pragma mark - Selection Handling

- (void) scrollToGridViewItem:(AZGVItem*) gridViewItem animated:(BOOL)animated  			{}
- (void) scrollToGridViewItemAtIndexPath:(NSIndexPath*) indexPath animated:(BOOL)animated 	{}
- (void) selectItemAtIndex:(NSUI)selectedItemIndex usingModifierFlags:(NSUI)modifierFlags
{
	AZGVItem *gridViewItem = nil;
	if (self.lastSelectedIndex != NSNotFound && self.lastSelectedIndex != selectedItemIndex) {
		/// inform the delegate
		[self gridView:self willDeselectItemAtIndex:self.lastSelectedIndex inSection:0];
		gridViewItem 			= self.keyedVisibleItems[@(self.lastSelectedIndex)];
		gridViewItem.isSelected = NO;
		[self.selectedItems removeObjectForKey:@(gridViewItem.index)];
		/// inform the delegate
		[self gridView:self didDeselectItemAtIndex:self.lastSelectedIndex inSection:0];
	}
	gridViewItem = self.keyedVisibleItems[@(selectedItemIndex)];
	if (gridViewItem) {
		/// inform the delegate
		[self gridView:self willSelectItemAtIndex:selectedItemIndex inSection:0];
		gridViewItem.isSelected = self.allowsMultipleSelection ? !gridViewItem.isSelected ? YES : modifierFlags & NSCommandKeyMask ? NO : gridViewItem.isSelected :  modifierFlags & NSCommandKeyMask ? !gridViewItem.isSelected : YES;
		self.lastSelectedIndex  = self.allowsMultipleSelection ? NSNotFound : selectedItemIndex;
		(self.selectedItems)[@(selectedItemIndex)] = gridViewItem;
		/// inform the delegate
		[self gridView:self didSelectItemAtIndex:selectedItemIndex inSection:0];
	}
}
- (void) handleClicks:(NSTimer*) theTimer
{
	NSUI clickCount = [self.clickEvents count];
	clickCount == CNSingleClick ?  [self handleSingleClickForItemAtIndex:[self indexForItemAtLocation:[self.clickEvents.lastObject locationInWindow]]]
  : clickCount == CNDoubleClick ? ^{
		NSUI indexClick1 = [self indexForItemAtLocation:[self.clickEvents[0] locationInWindow]];
		NSUI indexClick2 = [self indexForItemAtLocation:[self.clickEvents[1] locationInWindow]];
		if (indexClick1 == indexClick2)		 [self handleDoubleClickForItemAtIndex:indexClick1];
		else {								 [self handleSingleClickForItemAtIndex:indexClick1];
											 [self handleSingleClickForItemAtIndex:indexClick2];
}}():clickCount == CNTrippleClick ? ^{
		NSUI indexClick1 = [self indexForItemAtLocation:[self.clickEvents[0] locationInWindow]];
		NSUI indexClick2 = [self indexForItemAtLocation:[self.clickEvents[1] locationInWindow]];
		NSUI indexClick3 = [self indexForItemAtLocation:[self.clickEvents[2] locationInWindow]];
		if (indexClick1 == indexClick2 == indexClick3) 	[self handleDoubleClickForItemAtIndex:indexClick1];
		else if (indexClick1 == indexClick2 && indexClick1 != indexClick3) {
			[self handleDoubleClickForItemAtIndex:indexClick1];
			[self handleSingleClickForItemAtIndex:indexClick3];
		}
		else if (indexClick1 != indexClick2 && indexClick2 == indexClick3) {
			[self handleSingleClickForItemAtIndex:indexClick1];
			[self handleDoubleClickForItemAtIndex:indexClick3];
		}
		else if (indexClick1 != indexClick2 != indexClick3) {
			[self handleSingleClickForItemAtIndex:indexClick1];
			[self handleSingleClickForItemAtIndex:indexClick2];
			[self handleSingleClickForItemAtIndex:indexClick3];
		}
	}(): nil;
	[self.clickEvents removeAllObjects];
}
- (void) handleSingleClickForItemAtIndex:(NSUI)selectedItemIndex
{
	/// inform the delegate
	[self gridView:self didClickItemAtIndex:selectedItemIndex inSection:0];
	NSLog(@"handleSingleClick for item at index: %lu", selectedItemIndex);
}
- (void) handleDoubleClickForItemAtIndex:(NSUI)selectedItemIndex
{
	/// inform the delegate
	[self gridView:self didDoubleClickItemAtIndex:selectedItemIndex inSection:0];
	NSLog(@"handleDoubleClick for item at index: %lu", selectedItemIndex);
}
- (void) drawSelectionFrameForMousePointerAtLocation:(NSPoint)location
{
	if (!self.selectionFrameView) {
		self.selectionFrameInitialPoint = location;
		self.selectionFrameView = [[CNSelectionFrameView alloc] init];
		self.selectionFrameView.frame = NSMakeRect(location.x, location.y, 0, 0);
		if (![self containsSubView:self.selectionFrameView])
			[self addSubview:self.selectionFrameView];
	}
	else {
		NSR clippedRect = [self clippedRect];
		NSUI columnsInGridView = [self columnsInGridView];

		CGFloat posX = ceil((location.x > self.selectionFrameInitialPoint.x ? self.selectionFrameInitialPoint.x : location.x));
		posX = (posX < NSMinX(clippedRect) ? NSMinX(clippedRect) : posX);

		CGFloat posY = ceil((location.y > self.selectionFrameInitialPoint.y ? self.selectionFrameInitialPoint.y : location.y));
		posY = (posY < NSMinY(clippedRect) ? NSMinY(clippedRect) : posY);

		CGFloat width = (location.x > self.selectionFrameInitialPoint.x ? location.x - self.selectionFrameInitialPoint.x : self.selectionFrameInitialPoint.x - posX);
		width = (posX + width >= (columnsInGridView * self.itemSize.width) ? (columnsInGridView * self.itemSize.width) - posX - 1 : width);
		CGFloat height = (location.y > self.selectionFrameInitialPoint.y ? location.y - self.selectionFrameInitialPoint.y : self.selectionFrameInitialPoint.y - posY);
		height = (posY + height > NSMaxY(clippedRect) ? NSMaxY(clippedRect) - posY : height);
		NSR selectionFrame = NSMakeRect(posX, posY, width, height);
		self.selectionFrameView.frame = selectionFrame;
	}
}
- (void) selectItemsCoveredBySelectionFrame:(NSRect)selectionFrame usingModifierFlags:(NSUI)modifierFlags
{
	NSUI topLeftItemIndex = [self indexForItemAtLocation:[self convertPoint:NSMakePoint(NSMinX(selectionFrame), NSMinY(selectionFrame)) toView:nil]];
	NSUI bottomRightItemIndex = [self indexForItemAtLocation:[self convertPoint:NSMakePoint(NSMaxX(selectionFrame), NSMaxY(selectionFrame)) toView:nil]];
	CNItemPoint topLeftItemPoint = [self locationForItemAtIndex:topLeftItemIndex];
	CNItemPoint bottomRightItemPoint = [self locationForItemAtIndex:bottomRightItemIndex];
	/// handle all "by selection frame" selected items beeing now outside
	/// the selection frame
	[[self indexesForVisibleItems] enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
		AZGVItem *selectedItem = [self.selectedItems objectForKey:[NSNumber numberWithInteger:idx]];
		AZGVItem *selectionFrameItem = [self.selectedItemsBySelectionFrame objectForKey:[NSNumber numberWithInteger:idx]];
		if (selectionFrameItem) {
			CNItemPoint itemPoint = [self locationForItemAtIndex:selectionFrameItem.index];

			/// handle all 'out of selection frame range' items
			if ((itemPoint.row < topLeftItemPoint.row)			  ||  /// top edge out of range
				(itemPoint.column > bottomRightItemPoint.column)	||  /// right edge out of range
				(itemPoint.row > bottomRightItemPoint.row)		  ||  /// bottom edge out of range
				(itemPoint.column < topLeftItemPoint.column))		   /// left edge out of range
			{
				/// ok. before we deselect this item, lets take a look into our `keyedVisibleItems`
				/// if it there is selected too. If it so, keep it untouched!

				/// so, the current item wasn't selected, we can restore its old state (to unselected)
				if (![selectionFrameItem isEqual:selectedItem]) {
					selectionFrameItem.isSelected = NO;
					[self.selectedItemsBySelectionFrame removeObjectForKey:[NSNumber numberWithInteger:selectionFrameItem.index]];
				}

				/// the current item already was selected, so reselect it.
				else {
					selectionFrameItem.isSelected = YES;
					[self.selectedItemsBySelectionFrame setObject:selectionFrameItem forKey:[NSNumber numberWithInteger:selectionFrameItem.index]];
				}
			}
		}
	}];

	/// update all items that needs to be selected
	NSUI columnsInGridView = [self columnsInGridView];
	for (NSUI row = topLeftItemPoint.row; row <= bottomRightItemPoint.row; row++) {
		for (NSUI col = topLeftItemPoint.column; col <= bottomRightItemPoint.column; col++) {
			NSUI itemIndex = ((row -1) * columnsInGridView + col) -1;
			AZGVItem *selectedItem = [self.selectedItems objectForKey:[NSNumber numberWithInteger:itemIndex]];
			AZGVItem *itemToSelect = [self.keyedVisibleItems objectForKey:[NSNumber numberWithInteger:itemIndex]];
			[self.selectedItemsBySelectionFrame setObject:itemToSelect forKey:[NSNumber numberWithInteger:itemToSelect.index]];
			if (modifierFlags & NSCommandKeyMask) {
				itemToSelect.isSelected = ([itemToSelect isEqual:selectedItem] ? NO : YES);
			} else {
				itemToSelect.isSelected = YES;
			}
		}
	}
	
/**	/// handle all "by selection frame" selected items beeing now outside the selection frame
	[self.indexesForVisibleItems enumerateIndexesUsingBlock:^(NSUI idx, BOOL *stop) {
		AZGVItem *item = self.selectedItemsBySelectionFrame[[NSNumber numberWithInt:idx]];
		if (item) {
			CNItemPoint itemPoint = [self locationForItemAtIndex:item.index];
			if ( itemPoint.row	< topLeftItemPoint.row		||  /// top edge out of range
				 itemPoint.column > bottomRightItemPoint.column	||  /// right edge out of range
				 itemPoint.row 	  > bottomRightItemPoint.row	||  /// bottom edge out of range
				 itemPoint.column < topLeftItemPoint.column )		/// left edge out of range
			{
				/// ok. before we deselect this item, lets take a look into our `keyedVisibleItems`
				/// if it there is selected too. If it so, keep it untouched!

				/// so, the current item wasn't selected, we can restore its old state (to unselected)
				if (![selectionFrameItem isEqual:selectedItem]) {
					selectionFrameItem.selected = NO;
					[selectedItemsBySelectionFrame removeObjectForKey:[NSNumber numberWithInteger:selectionFrameItem.index]];
				}

				/// the current item already was selected, so reselect it.
				else {
					selectionFrameItem.selected = YES;
					[selectedItemsBySelectionFrame setObject:selectionFrameItem forKey:[NSNumber numberWithInteger:selectionFrameItem.index]];
				}

//				/// ok. before we deselect this item, lets take a look into our `keyedVisibleItems`
//				/// if it there is selected too. If it so, keep it untouched!
//				item.isSelected = NO;
//				[self.selectedItemsBySelectionFrame removeObjectForKey:@(item.index)];
			}
		}
	}];
	*/
	/// update all items that needs to be selected
//	NSUI columnsInGridView = self.columnsInGridView;
//	for (NSUI row = topLeftItemPoint.row; row <= bottomRightItemPoint.row; row++) {
//		for (NSUI col = topLeftItemPoint.column; col <= bottomRightItemPoint.column; col++) {
//			NSUI itemIndex = ((row -1) * columnsInGridView + col) -1;
//			AZGVItem *item = self.keyedVisibleItems[@(itemIndex)];
//			if (modifierFlags & NSCommandKeyMask)
//				item.isSelected = (item.isSelected ? NO : YES) ?: YES;
//			(self.selectedItemsBySelectionFrame)[@(item.index)] = item;
//		}
//	}
}

#pragma mark - Managing the Content
- (NSUI) numberOfVisibleItems  {	return _keyedVisibleItems.count;	}

- (void) removeItem:(AZGVItem*) theItem{}
- (void) removeItemAtIndex:(NSUI)index{}
- (void) removeAllItems{}
- (void) removeAllSelectedItems{}

#pragma mark - NSResponder Methods
- (void) mouseExited:(NSE*) theEvent {	self.lastHoveredIndex = NSNotFound; 	}

- (void) mouseMoved:(NSE*) theEvent
{
	if (!self.useHover)				 return;
	NSUI hoverItemIndex 		   = [self indexForItemAtLocation:theEvent.locationInWindow];
	if (hoverItemIndex 			  != NSNotFound || hoverItemIndex != self.lastHoveredIndex) {
		AZGVItem *gvItem   = nil;
		if (self.lastHoveredIndex != NSNotFound) {   /// unhover the last hovered item  + inform the delegate
			[self gridView:self willUnhovertemAtIndex:self.lastHoveredIndex inSection:0];
			gvItem 				   = self.keyedVisibleItems[@(self.lastHoveredIndex)];
			gvItem.isHovered 	   = NO;
		}									 		 /// inform the delegate
		[self gridView:self willHovertemAtIndex:hoverItemIndex inSection:0];
		self.lastHoveredIndex	   = hoverItemIndex;
		gvItem 		   			   = self.keyedVisibleItems[@(hoverItemIndex)];
		gvItem.isHovered 		   = YES;
	}
}
- (void) mouseDragged:(NSE*) theEvent
{
	if (!self.allowsMultipleSelection) return;
	[NSCursor pointingHandCursor];
	if (!self.abortSelection) {
		[self drawSelectionFrameForMousePointerAtLocation: [self convertPoint:theEvent.locationInWindow fromView:nil]];
		[self selectItemsCoveredBySelectionFrame:self.selectionFrameView.frame usingModifierFlags:theEvent.modifierFlags];
	}
}
- (void) mouseUp:(NSE*) theEvent
{
	[NSCursor arrowCursor];	/// remove selection frame
	[self.selectionFrameView.animator setAlphaValue:0];
	 self.selectionFrameView 	= nil;
	 self.abortSelection 		= NO;
	[self.selectedItems 		addEntriesFromDictionary:self.selectedItemsBySelectionFrame];
	[self.selectedItemsBySelectionFrame removeAllObjects];
	[self.clickEvents 			addObject:theEvent];
	 self.clickTimer 			= nil;
	 self.clickTimer 			= [NST scheduledTimerWithTimeInterval:NSE.doubleClickInterval target:self selector:@selector(handleClicks:) userInfo:nil repeats:NO];
}
- (void) mouseDown:(NSEvent*) theEvent
{
	if (!self.allowsSelection) return;
	[self selectItemAtIndex:[self indexForItemAtLocation:theEvent.locationInWindow] usingModifierFlags:theEvent.modifierFlags];
}
- (void) rightMouseDown:(NSEvent*) theEvent
{
	[self gridView:self rightMouseButtonClickedOnItemAtIndex:[self indexForItemAtLocation:theEvent.locationInWindow] inSection:0];
}

- (void) keyDown:(NSEvent*) theEvent
{
	AZLOG(@"keyDown"); [theEvent keyCode] == 53 /*escape*/ ?  ^{ self.abortSelection = YES; }() : nil;
}


#pragma mark - AZGView Delegate Calls
- (void) gridView:(AZGView*) gridView willHovertemAtIndex:(NSUI)index inSection:(NSUI)section
{
	![self.delegate respondsToSelector:_cmd] ?: [self.delegate gridView:gridView willHovertemAtIndex:index inSection:section];
}
- (void) gridView:(AZGView*) gridView willUnhovertemAtIndex:(NSUI)index inSection:(NSUI)section
{
	![self.delegate respondsToSelector:_cmd] ?: [self.delegate gridView:gridView willUnhovertemAtIndex:index inSection:section];
}
- (void) gridView:(AZGView*)gridView willSelectItemAtIndex:(NSUI)index inSection:(NSUI)section
{
	![self.delegate respondsToSelector:_cmd] ?: [self.delegate gridView:gridView willSelectItemAtIndex:index inSection:section];
}
- (void) gridView:(AZGView*)gridView didSelectItemAtIndex:(NSUI)index inSection:(NSUI)section
{
	![self.delegate respondsToSelector:_cmd] ?: [self.delegate gridView:gridView didSelectItemAtIndex:index inSection:section];
}
- (void) gridView:(AZGView*)gridView willDeselectItemAtIndex:(NSUI)index inSection:(NSUI)section
{
	![self.delegate respondsToSelector:_cmd] ?: [self.delegate gridView:gridView willDeselectItemAtIndex:index inSection:section];
}
- (void) gridView:(AZGView*)gridView didDeselectItemAtIndex:(NSUI)index inSection:(NSUI)section
{
	![self.delegate respondsToSelector:_cmd] ?: [self.delegate gridView:gridView didDeselectItemAtIndex:index inSection:section];
}
- (void) gridView:(AZGView*) gridView didClickItemAtIndex:(NSUI)index inSection:(NSUI)section
{
	![self.delegate respondsToSelector:_cmd] ?: [self.delegate gridView:gridView didClickItemAtIndex:index inSection:section];
}
- (void) gridView:(AZGView*) gridView didDoubleClickItemAtIndex:(NSUI)index inSection:(NSUI)section
{
	![self.delegate respondsToSelector:_cmd] ?: [self.delegate gridView:gridView didDoubleClickItemAtIndex:index inSection:section];
}
- (void) gridView:(AZGView*) gridView rightMouseButtonClickedOnItemAtIndex:(NSUI)index inSection:(NSUI)section
{
	![self.delegate respondsToSelector:_cmd] ?: [self.delegate gridView:gridView rightMouseButtonClickedOnItemAtIndex:index inSection:section];
}


#pragma mark - AZGView DataSource Calls
- (NSUI)gridView:(AZGView*) gridView numberOfItemsInSection:(NSI)section
{
	return [self.dataSource respondsToSelector:_cmd] ? [self.dataSource gridView:gridView numberOfItemsInSection:section] : NSNotFound;
}
- (AZGVItem*) gridView:(AZGView*) gridView itemAtIndex:(NSI)index inSection:(NSI)section
{
	return [self.dataSource respondsToSelector:_cmd] ? [self.dataSource gridView:gridView itemAtIndex:index inSection:section] : nil;
}
- (NSUI)numberOfSectionsInGridView:(AZGView*) gridView
{
	return [self.dataSource respondsToSelector:_cmd] ? [self.dataSource numberOfSectionsInGridView:gridView] : NSNotFound;
}
- (NSS*) gridView:(AZGView*) gridView titleForHeaderInSection:(NSI)section
{
	return  [self.dataSource respondsToSelector:_cmd] ? [self.dataSource gridView:gridView titleForHeaderInSection:section] : nil;
}
- (NSA*) sectionIndexTitlesForGridView:(AZGView*) gridView
{
	return   [self.dataSource respondsToSelector:_cmd]  ? [self.dataSource sectionIndexTitlesForGridView:gridView] : nil;
}

#pragma mark - AZGView Item Default Colors
- (NSC*) itemBackgroundColor
{
	return _itemBackgroundColor ?: GRAY2;///[NSC colorWithCalibratedWhite:0.238 alpha:1.000];
}
- (NSC*) itemBackgroundHoverColor
{
	return _itemBackgroundHoverColor ?: GREEN;
}
- (NSC*) itemBackgroundSelectionColor
{
	return _itemBackgroundSelectionColor ?: GRAY5;//[NSC colorWithCalibratedWhite:0.172 alpha:1.000];
}
- (NSC*) itemSelectionRingColor
{
	return _itemSelectionRingColor ?: WHITE;//[NSC colorWithCalibratedWhite:0.740 alpha:1.000];
}
- (NSC*) itemTitleColor
{
	return _itemTitleColor ?: GRAY9;//[NSC colorWithDeviceRed:0.969 green:0.994 blue:0.994 alpha:1.000];
}
- (NSC*) itemTitleShadowColor
{
	return _itemTitleShadowColor ?: BLACK;//[NSC colorWithDeviceWhite:0.011 alpha:0.930];
}
- (NSC*) selectionFrameColor
{
	return _selectionFrameColor ?: [NSC colorWithCalibratedRed:0.908 green:0.784 blue:0.170 alpha:1.000];
}
- (NSC*) backgroundColor
{
	return _backgroundColor ?: GRAY8;//[NSC colorWithCalibratedWhite:0.137 alpha:1.000];
}

//+ (AZGVItemLayout*) defaultLayout
//{
//	AZGVItemLayout *defaultLayout = [[self class] new];
//	return defaultLayout;
//}

@end

static CGF mPhase = 0;

#pragma mark - CNSelectionFrameView
@implementation CNSelectionFrameView { NSTimer *timer; }

- (void) drawRect:(NSRect)rect
{
	
	NSR dirtyRect = NSMakeRect(0.5, 0.5, floorf(NSWidth(self.bounds))-1, floorf(NSHeight(self.bounds))-1);

	NSBP *selectionFramePath = [NSBP bezierPathWithRoundedRect:dirtyRect xRadius:0 yRadius:0];
	[selectionFramePath fillWithColor:[GRAY4 alpha:0.42]];
	[selectionFramePath strokeWithColor:WHITE andWidth:8 inside:dirtyRect];
//	DKStrokeDash *d = DKStrokeDash.defaultDash;//;equallySpacedDashToFitSize:dirtyRect.size dashLength:40];
////	[d setScalesToLineWidth:YES];//setPhase:phase];
//	[d setPhase:mPhase];
//	[d applyToPath:selectionFramePath];
	[selectionFramePath strokeWithColor:BLACK andWidth:8 inside:dirtyRect];
	mPhase += 5;
//	timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(aniHandler:) userInfo:nil repeats:YES];
	timer =	[NSTimer timerWithTimeInterval:.5 block:^(NSTimer *tmr) { [self display];/*:YES];*/ AZLOG($(@"NSTIMER %@!", tmr));	} repeats:NO];
}
- (BOOL)isFlipped
{
	return YES;
}

- (void)aniHandler:(NSTimer*)timer {

	CGF halfwayWithInset = AZPerimeterWithRoundRadius( self.frame,/*radiuus*/ 0 );
	mPhase = mPhase < halfwayWithInset ? mPhase + halfwayWithInset / 128 : 0;
	[self setNeedsDisplayInRect:NSInsetRect(self.bounds, 8, 8)];
}
@end


@interface AZGVItem ()
@property (strong) NSImageView *itemImageView;
//@property (strong, nonatomic) CAShapeLayer *selectionLayer;
//@property (strong) AZGVItemLayout *currentLayout;
@end
@implementation AZGVItem

//#pragma mark - Initialzation
+ (void)initialize
{
	kCNDefaultItemIdentifier = @"AZGVItem";
	//	kDefaultItemSize		 = NSMakeSize(96, 96);
}
//+ (CGSize)defaultItemSize
//{
//	return kDefaultItemSize;
//}
- (id)init
{
	if (!(self = [super init])) return nil;
	[self initProperties];
	return self;
}
- (id)initWithCoder:(NSCoder*) aDecoder
{
	if (!(self = [super initWithCoder:aDecoder])) return nil;
	[self initProperties];
	return self;
}
- (id)initInGrid:(AZGView *)grid reuseIdentifier:(NSString *)reuseIdentifier
{
	if (!(self = [super init])) return nil;
	_grid = grid;
	[self initProperties];
	//	_standardLayout = layout;
	//	_reuseIdentifier = reuseIdentifier;
	return self;
}
- (void) initProperties
{
	//	self.wantsLayer		= YES;
	/// Reusing Grid View Items
	_reuseIdentifier 	= kCNDefaultItemIdentifier;
	/// Item Default Content
	_itemImage	 		= nil;
	_itemTitle 			= @"";
	_index 				= CNItemIndexNoIndex;
	/// Grid View Item Layout

	//	_standardLayout 	= [AZGVItemLayout defaultLayout];
	//	_hoverLayout 		= [AZGVItemLayout defaultLayout];
	//	_selectionLayout 	= [AZGVItemLayout defaultLayout];
	//	_currentLayout 		= _standardLayout;
	_useLayout 			= YES;
	/// Selection and Hovering
	_isSelected	 		= NO;
	_isSelectable 		= YES;
	_isHovered 			= NO;
}
- (BOOL)isFlipped
{
	return YES;
}


#pragma mark - Reusing Grid View Items
- (void) prepareForReuse
{
	self.itemImage 		= nil;
	self.itemTitle 		= @"";
	self.index 			= CNItemIndexNoIndex;
	self.isSelected 	= NO;
	self.isSelectable 	= YES;
	self.isHovered 		= NO;
}


#pragma mark - ViewDrawing
- (void) drawRect:(NSRect)rect
{
	NSR dirtyRect = self.bounds;
	// decide which layout we have to use
	/// contentRect is the rect respecting the value of layout.contentInset
	NSR contentRect = NSMakeRect(dirtyRect.origin.x + self.grid.contentInset, //self.currentLayout.contentInset,
									dirtyRect.origin.y + self.grid.contentInset, //self.currentLayout.contentInset,
									dirtyRect.size.width - self.grid.contentInset * 2, //self.currentLayout.contentInset * 2,
									dirtyRect.size.height - self.grid.contentInset * 2); //self.currentLayout.contentInset * 2);
	NSBP *contentRectPath = [NSBP bezierPathWithRoundedRect:contentRect
																	xRadius:self.grid.itemBorderRadius //self.currentLayout.itemBorderRadius
																	yRadius:self.grid.itemBorderRadius];//self.currentLayout.itemBorderRadius];
	[self.itemColor ?: self.grid.itemBackgroundColor setFill];//currentLayout.itemBackgroundColor setFill];
	[contentRectPath fill];
	if (self.isSelected) [self.grid.itemBackgroundSelectionColor setFill];
	[contentRectPath fill];
	if (self.isHovered) [self.grid.itemBackgroundHoverColor setFill];
	[contentRectPath fill];

	/// draw selection ring
	if (self.isSelected) {
		[self.grid.itemSelectionRingColor setStroke];//currentLayout.itemSelectionRingColor setStroke];
		[contentRectPath setLineWidth:self.grid.selectionRingLineWidth];//currentLayout.selectionRingLineWidth];
		[contentRectPath stroke];
	}

	//	NSR srcRect = NSZeroRect;
	//	srcRect.size = self.itemImage.size;
	NSR imageRect = NSInsetRect([self bounds], self.grid.contentInset*2, self.grid.contentInset*2);//NSZeroRect;
	NSR textRect = NSZeroRect;
	if (self.grid.visibleContentMask & (AtoZGridViewItemVisibleContentImage | AtoZGridViewItemVisibleContentTitle)) {
		//currentLayout.visibleContentMask & (AtoZGridViewItemVisibleContentImage | AtoZGridViewItemVisibleContentTitle)) {
		//		imageRect = NSMakeRect(((NSWidth(contentRect) - self.itemImage.size.width) / 2) + self.currentLayout.contentInset,
		//							   self.currentLayout.contentInset + 10,
		//							   self.itemImage.size.width,
		//							   self.itemImage.size.height);
		[self.itemImage drawInRect:imageRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
		if (self.isHovered) {
			textRect = NSMakeRect(contentRect.origin.x + 3,
								  NSHeight(contentRect) - 6,
								  NSWidth(contentRect) - 6,
								  14);
			[self.itemTitle drawInRect:textRect withAttributes:self.grid.itemTitleTextAttributes];
		}
	}
	else if (self.grid.visibleContentMask & AtoZGridViewItemVisibleContentImage) {
		//		imageRect = NSMakeRect(((NSWidth(contentRect) - self.itemImage.size.width) / 2) + self.currentLayout.contentInset,
		//							   ((NSHeight(contentRect) - self.itemImage.size.height) / 2) + self.currentLayout.contentInset,
		//							   self.itemImage.size.width,
		//							   self.itemImage.size.height);
	}
	else if (self.grid.visibleContentMask & AtoZGridViewItemVisibleContentTitle) {
	}
}


#pragma mark - Notifications
//- (void) clearHovering
//{
//	self.isHovered = NO;
//}
//- (void) clearSelection
//{
//	self.isSelected = NO;
//}


//- (CAShapeLayer*)selectionLayer {
//	CAShapeLayer *layer = _selectionLayer ?: [CAShapeLayer layer];
//	NSBP *path = [NSBP bezierPathWithRoundedRect:self.bounds xRadius:self.grid.itemBorderRadius yRadius:self.grid.itemBorderRadius];
////	layer.path =
//	return layer;
//}

#pragma mark - Accessors
- (void) setIsHovered:(BOOL)isHovered
{
	_isHovered = isHovered;
	//	_currentLayout = (isHovered ? _hoverLayout : (_isSelected ? _selectionLayout : _standardLayout));
	[self setNeedsDisplay:YES];
}
- (void) setIsSelected:(BOOL)isSelected
{
	_isSelected = isSelected;
	//	_currentLayout = isSelected ? _selectionLayout : _standardLayout;
	[self setNeedsDisplay:YES];
}
- (BOOL)isReuseable{
	return _isSelected ? NO : YES;
}

@end

@class AZSizer;
@implementation  AtoZGridViewAuto

- (NSUI) countOfItems 												 {  return self.items.count;							   }
- (id)   objectInItemsAtIndex: (NSUI)index 							 {  return self.items[index]; 							   }
- (void) insertObject:(id)obj inItemsAtIndex: (NSUI)index 			 {  self.items[index] = obj; 							   }
- (void) removeObjectFromItemsAtIndex: (NSUI)index 					 { [self.items removeObjectAtIndex:index]; 				   }
- (void) replaceObjectInItemsAtIndex: (NSUI)index withObject:(id)obj { [self.items replaceObjectAtIndex:index withObject:obj]; }

- (void) awakeFromNib {
	if (!_items) self.items = NSMA.new;
//	[self addObserver:self keyPath:@"items" options:(NSKeyValueChangeInsertion|NSKeyValueChangeReplacement) block:^(MAKVONotification *notification) {
//		NSLog(@"autogrid kvo notified of item insertion.  reloading");
//		[self.grid reloadData];	}];
}
-(void) scrollWheel:(NSE*)e
{
	self.grid.itemSize = AZAddSizes(_grid.itemSize, AZSizeFromDimension(e.deltaX));
	[self.nextResponder scrollWheel:e];
}
- (void) viewDidMoveToSuperview
{
	NSR superF = self.superview.bounds;
//	NSLog(@"Autogrid did move to superV. self:%@ items:%@", AZString(self.frame), self.items);
	[@[self, self.scrollView, self.grid] do:^(NSV* obj) { if (! NSEqualSizes(obj.size, superF.size)) obj.frame = superF; }];
	!_items ?: [self.grid reloadData];
//	if (_items.count != 0) [_grid reloadData];
}

- (NSSCRLV*) scrollView {
	return _scrollView ?: ^{
		self.scrollView					= [NSSCRLV.alloc initWithFrame:self.bounds];
		_scrollView.bgC					= [NSC leatherTintedWithColor:RANDOMCOLOR];
		_scrollView.arMASK 				= NSSIZEABLE;
		_scrollView.borderType 			= NSNoBorder;
		_scrollView.documentView		= self.grid;
		[self addSubview:_scrollView];
		return _scrollView;
	}();
}

- (void) setItems:(NSMA*)items
{
	_items = [items cw_mapArray:^id(NSO* obj) {

		return 	@{ 	kContentImageKey: obj.imageValue ?: [NSIMG imageNamed:@"missing"] ELSENULL,
					kContentTitleKey: [obj respondsToString:@"name"] ? [obj valueForKey:@"name"] : @"N/A",
					kContentColorKey: obj.colorValue ELSENULL } ?: nil;
	}].mutableCopy;
}

- (AZGV*)grid
{
	return _grid ?: ^{
		self.grid 				= [AZGView.alloc initWithFrame:self.bounds];
		_grid.arMASK			= NSSIZEABLE;
//		_grid.delegate 			= self;
		_grid.dataSource 		= self;
		_grid.scrollElasticity 	= NO;
		_grid.allowsMultipleSelection = YES;
		_grid.itemSize 			= (NSSize){65,65};
		return _grid;
	}();
}
-(id) initWithFrame:(NSR)frame andArray:(NSArray *)array  // inView:(NSView *)view
{
	if (self != [super initWithFrame:frame]) return nil;
	self.autoresizesSubviews = YES;
	self.arMASK 		= NSSIZEABLE;
	self.items = array.mutableCopy;
	return self;
}
//- (BOOL)acceptsFirstResponder {	return YES; }

//- (void) scrollWheel:(NSEvent *)theEvent
//{
//		AZLOG(theEvent);
//		self.grid.itemSize = AZAddSizes(self.grid.itemSize, AZSizeFromDimension(theEvent.deltaX));
//		[[self nextResponder] scrollWheel:theEvent];
//}

//	[NSEVENTLOCALMASK: NSLeftMouseUpMask | NSScrollWheelMask | NSEventMaskGesture | NSEventMaskMagnify handler:^NSEvent *(NSEvent *e) {
//
//		if ([e type] == NSEventTypeMagnify ) {
//
//			NSSize size = _grid.itemSize;
//			size = AZMultiplySize(size, e.magnification);
//
//			self.grid.itemSize = size;
//		}
//		if ( e.type == NSLeftMouseUp && [e clickCount] == 3 ) {
//			//			grid.itemSize = [AZSizer forQuantity:_array.count inRect:self.bounds].size;
//			//			NSSize s = _grid.itemSize;
//			//			s.width += 10;
//			//			s.height += 10;
//			//			_grid.itemSize = s;
//			//			[grid reloadData];
//			//		AZSizer *sizer = [AZSizer forQuantity: _array.count aroundRect:_grid.enclosingScrollView.contentView.frame];
//			//		AZLOG(sizer.propertiesPlease);
//			//		_grid.itemSize = sizer.size;
//		}
//		}
//		return e;
//	}];

//-(void) setItemSize:(NSSize)itemSize
//{
//	_itemSize = itemSize;
//	self.grid.itemSize = _itemSize;
//	[self.grid reloadData];
//}

- (NSUI)gridView:(AZGView*) gridView numberOfItemsInSection:(NSInteger)section
{
	NSLog(@"gris view items reported as %ld", self.items.count);
	return self.items.count;
}
- (AZGVItem*) gridView:(AZGView*) gridView itemAtIndex:(NSI)index inSection:(NSI)section
{
	if (self.items.count == 0) return nil;
	AZGVItem *item  = 	[gridView dequeueReusableItemWithIdentifier:reuseIdentifier] ?:
//	if (item) { NSLog(@"did dequeue index: %lu item: %@", index, item);

		[AZGVItem.alloc initInGrid:_grid reuseIdentifier:reuseIdentifier];
//		NSLog(@"did create item for index: %lu", index);
//	}
	NSDictionary *contentDict = self.items[index];
	item.itemTitle = contentDict [kContentTitleKey] ELSENULL;
	item.itemImage = contentDict [kContentImageKey] ELSENULL;
	item.itemColor = contentDict [kContentColorKey] ELSENULL;
//	NSLog(@"Returning cell for index: %ld, cell:%@", index, item.propertiesPlease);
	return item;
}


#pragma mark - AZGView Delegate
- (void) gridView:(AZGView*) gridView rightMouseButtonClickedOnItemAtIndex:(NSUI)index inSection:(NSUI)section
{
	NSLog(@"rightMouseButtonClickedOnItemAtIndex: %li", index);
}
@end

