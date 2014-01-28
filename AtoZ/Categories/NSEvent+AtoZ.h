JREnumDeclare(AZEvent, AZEventLeftMouseDown = 1,
				   AZEventLeftMouseUp,
				   AZEventRightMouseDown,
				   AZEventRightMouseUp,
				   AZEventMouseMoved,
				   AZEventLeftMouseDragged,
				   AZEventRightMouseDragged,
				   AZEventMouseEntered,
				   AZEventMouseExited,
				   AZEventKeyDown,
				   AZEventKeyUp,
				   AZEventFlagsChanged,
				   AZEventAppKitDefined,
				   AZEventSystemDefined,
				   AZEventApplicationDefined,
				   AZEventPeriodic,
				   AZEventCursorUpdate,
				   AZEventScrollWheel,
				   AZEventTabletPoint,
				   AZEventTabletProximity,
				   AZEventOtherMouseDown,
				   AZEventOtherMouseUp,
				   AZEventOtherMouseDragged,
				   AZEventEventTypeGesture,
				   AZEventEventTypeMagnify,
				   AZEventEventTypeSwipe,
				   AZEventEventTypeRotate,
				   AZEventEventTypeBeginGesture,
				   AZEventTypeEndGesture);

/* USAGE:	
@property (UNSFE) IBOutlet NSButton 	*someButton;
...  .m
[_someButton setActionBlock:(NSControlActionBlock) ^(id inSender) { AZLOG(@"xlisidud"); [self doSomeBullshit:nil];	}];
*/

typedef void(^NSControlActionBlock)(id sender);
typedef void(^NSControlEventActionBlock)(AZEvent e,id sender);
typedef void(^NSControlVoidActionBlock)(void);


@interface NSColorPanel (AtoZ)
@property (nonatomic,copy) void(^actionBlock)(id);
@end


@protocol NSActionBlock <NSObject>
@concrete
@property (nonatomic,copy) void(^actionBlock)(id);
@property (nonatomic,copy) void(^voidActionBlock)(void);
@end

@interface NSControl (AtoZ)
- (void) setAction:(SEL)method withTarget:(id)object;
- (void) setActionString:(NSS*)methodasString withTarget:(id)object;
@property (copy) void(^eventActionBlock)(AZEvent e,id sender);
@end

//typedef void (^whileDragging)(void);
//typedef void (^insideDrag)(NSE*, NSP, whileDragging);
typedef void (^EventBlock)(NSE* e);

@interface NSEvent (AtoZ)

//+ (void) dragBlock:(void(^)(NSP click, NSP delta))block;

/*	- (void) scrollWheel:(NSEvent *)theEvent	{	self.offset = [theEvent scrollOffsetInView:self];	
																						    [self setNeedsDisplay:YES];	} */
- (NSSZ) scrollOffsetInView:(NSV*)view;
/*	- (void)magnifyWithEvent:(NSEvent *)event {	[self setFrame:[event magnifyRect:self.frame]]; */
- (NSR) magnifyRect:(NSR)rect;
//- (whileDragging)dragBlock:(NSE*)e;
+ (void)whileDragging:(void(^)(NSE* click, NSE*drag))block;
+ (void) shiftClick:(void(^)(void))block;
//+ (NSE*) whileDragging:(whileDragging)whileDraggingBlock;
- (id) dragHandlerForClickWithBlock:(void(^)(NSE*click, NSE*drag)) block;
@end


@interface NSTV (TargetAction)
@property (readwrite, nonatomic, copy) NSControlVoidActionBlock doubleActionBlock;
- (void) setDoubleAction:(SEL)method withTarget:(id)object;
- (void) setDoubleActionString:(NSS*)methodasString withTarget:(id)object;
//- (void) setDoubleActionBlock:(NSControlVoidActionBlock)block;

@end
