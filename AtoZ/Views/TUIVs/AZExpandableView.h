
@interface AZExpandableView : TUIView

@property (RONLY) NSIMG		*favicon;
@property (RONLY) NSC		  *color;
@property (RONLY)	NSS 		 *string;
@property (RONLY)	NSURL			 *url;
@property (RONLY)	NSAS	*attrString;
@property (RONLY)	BOOL 	  		  faviconOK;

@property (NATOM,STRNG)	NSMD  *dictionary;
//@property (NATOM,   WK) NSMA  	*objects;
@property (NATOM, ASS)	BOOL	   expanded,
											selected;
@end

