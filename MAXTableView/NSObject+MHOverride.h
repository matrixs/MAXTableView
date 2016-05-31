#import <Foundation/Foundation.h>

@interface NSObject (MHOverride)

/*
 * Dynamically overrides the specified method on this particular instance.
 *
 * The block's parameters and return type must match those of the method you
 * are overriding. However, the first parameter is always "id _self", which
 * points to the object itself.
 *
 * You do have to cast the block's type to (__bridge void *), e.g.:
 *
 *     [self mh_overrideSelector:@selector(viewDidAppear:)
 *                     withBlock:(__bridge void *)^(id _self, BOOL animated) { ... }];
 */
- (BOOL)mh_overrideSelector:(SEL)selector withBlock:(void *)block;

/*
 * To call super from the overridden method, do the following:
 * 
 *     SEL sel = @selector(viewDidAppear:);
 *     void (*superIMP)(id, SEL, BOOL) = [_self mh_superForSelector:sel];
 *     superIMP(_self, sel, animated);
 *
 * This first gets a function pointer to the super method and then you call it.
 */
- (void *)mh_superForSelector:(SEL)selector;

@end
