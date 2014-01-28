
//  Copyright 2009-10 Alex Rozanski http://persAZ.com  05/09/2009.

/*	An example of a class that could be used to represent a Source List Item
	 Provides a title, an identifier, and an icon to be shown, as well as a badge value and a property to determine whether the current item has a badge or not (`badgeValue` is set to -1 if no badge is shown)
	Used to form a hierarchical model of SourceListItem instances – similar to the Source List tree structure and easily accessible by the data source with the "children" property
 
	SourceListItem *parent
	- SourceListItem *child1;
	- SourceListItem *child2;
	- SourceListItem *childOfChild2;
	- SourceListItem *anotherChildOfChild2;
	- SourceListItem *child3;

*/


@interface SourceListItem : NSObject

@property (WK) 	  id 	objectRep;
@property (STRNG) NSC	*color;
@property (CP) 	  NSS 	*title, *identifier;
@property (STRNG) NSIMG *icon;
@property (ASS)   NSI 	badgeValue;
@property (STRNG) NSA 	*children;

//Convenience methods
+ (id)itemWithTitle:(NSString*)aTitle identifier:(NSString*)anIdentifier;
+ (id)itemWithTitle:(NSString*)aTitle identifier:(NSString*)anIdentifier icon:(NSImage*)anIcon;
- (BOOL)hasBadge;
- (BOOL)hasChildren;
- (BOOL)hasIcon;

@end


@class JsonResource;
@interface JSONListItem : SourceListItem

+ (id)itemWithTitle:(NSString*)aTitle identifier:(NSString*)anIdentifier fromJson:(JsonResource*)anIcon;

@end

@protocol AZSourceListDelegate, AZSourceListDataSource;
@interface AZSourceList: NSOutlineView <NSOutlineViewDelegate, NSOutlineViewDataSource>
{
	id <AZSourceListDelegate> _secondaryDelegate;
	id <AZSourceListDataSource> _secondaryDataSource;		
	NSSize _iconSize;
}

@property (nonatomic, assign) NSSize iconSize;  						//	The size of icons in the Source List. Defaults to 16x16
@property (unsafe_unretained) id<AZSourceListDataSource> dataSource;	//	Used to store the publicly visible data source
@property (unsafe_unretained) id<AZSourceListDelegate> delegate;		//	Used to store the publicly visible delegate

- (NSUInteger)numberOfGroups;							//Returns the number of groups in the Source List
- (BOOL)isGroupItem:(id)item;							//Returns whether `item` is a group
- (BOOL)isGroupAlwaysExpanded:(id)group;				//Returns whether `group` is displayed as always expanded

- (BOOL)itemHasBadge:(id)item;							//Returns whether `item` has a badge
- (NSInteger)badgeValueForItem:(id)item;				//Returns the badge value for `item`
@end


@protocol AZSourceListDataSource <NSObject>
@required
- (NSUInteger)sourceList:(AZSourceList*)sourceList numberOfChildrenOfItem:(id)item;
- (id)sourceList:(AZSourceList*)aSourceList child:(NSUInteger)index ofItem:(id)item;
- (id)sourceList:(AZSourceList*)aSourceList objectValueForItem:(id)item;
- (BOOL)sourceList:(AZSourceList*)aSourceList isItemExpandable:(id)item;

@optional
- (void)sourceList:(AZSourceList*)aSourceList setObjectValue:(id)object forItem:(id)item;

- (BOOL)sourceList:(AZSourceList*)aSourceList itemHasBadge:(id)item;
- (NSInteger)sourceList:(AZSourceList*)aSourceList badgeValueForItem:(id)item;
- (NSColor*)sourceList:(AZSourceList*)aSourceList badgeTextColorForItem:(id)item;
- (NSColor*)sourceList:(AZSourceList*)aSourceList badgeBackgroundColorForItem:(id)item;

- (BOOL)sourceList:(AZSourceList*)aSourceList itemHasIcon:(id)item;
- (NSImage*)sourceList:(AZSourceList*)aSourceList iconForItem:(id)item;

//The rest of these methods are basically "wrappers" for the NSOutlineViewDataSource methods
- (id)sourceList:(AZSourceList*)aSourceList itemForPersistentObject:(id)object;
- (id)sourceList:(AZSourceList*)aSourceList persistentObjectForItem:(id)item;

- (BOOL)sourceList:(AZSourceList*)aSourceList writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pboard;
- (NSDragOperation)sourceList:(AZSourceList*)sourceList validateDrop:(id < NSDraggingInfo >)info proposedItem:(id)item proposedChildIndex:(NSInteger)index;
- (BOOL)sourceList:(AZSourceList*)aSourceList acceptDrop:(id < NSDraggingInfo >)info item:(id)item childIndex:(NSInteger)index;
- (NSArray *)sourceList:(AZSourceList*)aSourceList namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropDestination forDraggedItems:(NSArray *)items;

@end

@protocol AZSourceListDelegate <NSObject>
@optional
//Extra methods
- (BOOL)sourceList:	(AZSourceList*)aSourceList isGroupAlwaysExpanded:(id)group;
- (NSMenu*)sourceList: (AZSourceList*)aSourceList menuForEvent:(NSEvent*)theEvent item:(id)item;

//Basically NSOutlineViewDelegate wrapper methods
- (NSIS*)sourceList:(AZSourceList*)aSourceList selectionIndexesForProposedSelection:(NSIS*)proposedSelectionIndexes;

- (BOOL)sourceList: (AZSourceList*)aSourceList shouldSelectItem:  (id)item;
- (BOOL)sourceList: (AZSourceList*)aSourceList shouldEditItem:	(id)item;
- (BOOL)sourceList: (AZSourceList*)aSourceList shouldExpandItem:  (id)item;
- (BOOL)sourceList: (AZSourceList*)aSourceList shouldCollapseItem:(id)item;
- (BOOL)sourceList: (AZSourceList*)aSourceList shouldTrackCell:   (NSCell*)cell forItem:(id)item;

- (NSCell*)sourceList: (AZSourceList*)aSourceList willDisplayCell:(id)cell 		forItem:(id)item;
- (NSCell*)sourceList: (AZSourceList*)aSourceList dataCellForItem:(id)item;

- (CGF)sourceList: (AZSourceList*)aSourceList heightOfRowByItem:(id)item;


@end

@interface NSObject (AZSourceListNotifications)

//Selection
- (void)sourceListSelectionIsChanging: (NSNOT*) notification;
- (void)sourceListSelectionDidChange:  (NSNOT*) notification;

//Item expanding/collapsing
- (void)sourceListItemWillExpand:   (NSNOT*) notification;
- (void)sourceListItemDidExpand:	(NSNOT*) notification;
- (void)sourceListItemWillCollapse: (NSNOT*) notification;
- (void)sourceListItemDidCollapse:  (NSNOT*) notification;

- (void)sourceListDeleteKeyPressedOnRows: (NSNOT*) notification;
@end

//AZSourceList delegate notifications
extern NSString * const AZSLSelectionIsChangingNotification		;
extern NSString * const AZSLSelectionDidChangeNotification		;
extern NSString * const AZSLItemWillExpandNotification			;
extern NSString * const AZSLItemDidExpandNotification			;
extern NSString * const AZSLItemWillCollapseNotification			;
extern NSString * const AZSLItemDidCollapseNotification			;
extern NSString * const AZSLDeleteKeyPressedOnRowsNotification	;

//{	NSString *title;	NSString *identifier;	NSImage *icon;  NSInteger badgeValue; NSArray *children;}
//{
//	id <AZSourceListDelegate> _secondaryDelegate;		
//	id <AZSourceListDataSource> _secondaryDataSource;		
//	NSSize _iconSize;
//}

//#ifndef MAC_OS_X_VERSION_10_6
//@protocol NSOutlineViewDelegate <NSObject> @end
//@protocol NSOutlineViewDataSource <NSObject> @end
//#endif
