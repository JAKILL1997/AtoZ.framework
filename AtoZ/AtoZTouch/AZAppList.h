
@import AtoZUniversal;

_Type NS_ENUM(_UInt,AZAppIconSize){  AZAppIconSizeSmall = 29,
                                     AZAppIconSizeLarge = 59  };

@Kind(AZAppList) + _Kind_ list; _RO _Dict apps; _RO _UInt appCount;

- _List_ appsFilteredUsingPredicate:(NSPredicate*)predicate;

- valueForKeyPath:_Text_ kp forDisplayIdentifier:_Text_ dispID;
-     valueForKey:_Text_ kp forDisplayIdentifier:_Text_ dispID;

- _Pict_           iconOfSize:(AZAppIconSize)z forDisplayIdentifier:_Text_ dispID;
- _IsIt_  hasCachedIconOfSize:(AZAppIconSize)z forDisplayIdentifier:_Text_ dispID;
- (CGImageRef) copyIconOfSize:(AZAppIconSize)z forDisplayIdentifier:_Text_ dispID CF_RETURNS_RETAINED;

@Stop

extern Text *const ALIconLoadedNotification,
            *const ALDisplayIdentifierKey,
            *const ALIconSizeKey;
