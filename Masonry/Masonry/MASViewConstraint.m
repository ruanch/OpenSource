//
//  MASViewConstraint.m
//  Masonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "MASViewConstraint.h"
#import "MASConstraint+Private.h"
#import "MASCompositeConstraint.h"
#import "MASLayoutConstraint.h"
#import "View+MASAdditions.h"
#import <objc/runtime.h>

@interface MAS_VIEW (MASConstraints)

@property (nonatomic, readonly) NSMutableSet *mas_installedConstraints;

@end

@implementation MAS_VIEW (MASConstraints)

static char kInstalledConstraintsKey;

- (NSMutableSet *)mas_installedConstraints {
    NSMutableSet *constraints = objc_getAssociatedObject(self, &kInstalledConstraintsKey);
    if (!constraints) {
        constraints = [NSMutableSet set];
        objc_setAssociatedObject(self, &kInstalledConstraintsKey, constraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return constraints;
}

@end


@interface MASViewConstraint ()

@property (nonatomic, strong, readwrite) MASViewAttribute *secondViewAttribute;
@property (nonatomic, weak) MAS_VIEW *installedView;
@property (nonatomic, weak) MASLayoutConstraint *layoutConstraint;
@property (nonatomic, assign) NSLayoutRelation layoutRelation;
@property (nonatomic, assign) MASLayoutPriority layoutPriority;
@property (nonatomic, assign) CGFloat layoutMultiplier;
@property (nonatomic, assign) CGFloat layoutConstant;
@property (nonatomic, assign) BOOL hasLayoutRelation;
@property (nonatomic, strong) id mas_key;
@property (nonatomic, assign) BOOL useAnimator;

@end

@implementation MASViewConstraint

//初始化第一个视图属性值
- (id)initWithFirstViewAttribute:(MASViewAttribute *)firstViewAttribute {
    self = [super init];
    if (!self) return nil;
    
    _firstViewAttribute = firstViewAttribute;
    //默认值1000
    self.layoutPriority = MASLayoutPriorityRequired;
    //比例 1
    self.layoutMultiplier = 1;
    
    return self;
}

#pragma mark - NSCoping

- (id)copyWithZone:(NSZone __unused *)zone {
    MASViewConstraint *constraint = [[MASViewConstraint alloc] initWithFirstViewAttribute:self.firstViewAttribute];
    constraint.layoutConstant = self.layoutConstant;
    constraint.layoutRelation = self.layoutRelation;
    constraint.layoutPriority = self.layoutPriority;
    constraint.layoutMultiplier = self.layoutMultiplier;
    constraint.delegate = self.delegate;
    return constraint;
}

#pragma mark - Public
//获取指定视图所有约束集合
+ (NSArray *)installedConstraintsForView:(MAS_VIEW *)view {
    return [view.mas_installedConstraints allObjects];
}

#pragma mark - Private
//设置约束的值
- (void)setLayoutConstant:(CGFloat)layoutConstant {
    _layoutConstant = layoutConstant;

#if TARGET_OS_MAC && !(TARGET_OS_IPHONE || TARGET_OS_TV)
    if (self.useAnimator) {
        [self.layoutConstraint.animator setConstant:layoutConstant];
    } else {
        self.layoutConstraint.constant = layoutConstant;
    }
#else
    self.layoutConstraint.constant = layoutConstant;
#endif
}
//设置布局关系
- (void)setLayoutRelation:(NSLayoutRelation)layoutRelation {
    _layoutRelation = layoutRelation;
    self.hasLayoutRelation = YES;
}
//是否有实现激活属性
- (BOOL)supportsActiveProperty {
    return [self.layoutConstraint respondsToSelector:@selector(isActive)];
}
//iOS 6.0或者7.0调用addConstraints
//[self.view addConstraints:@[leftConstraint, rightConstraint, topConstraint, heightConstraint]];
//iOS 8.0以后设置active属性值 就可以去使用约束了
- (BOOL)isActive {
    BOOL active = YES;
    if ([self supportsActiveProperty]) {
        active = [self.layoutConstraint isActive];
    }

    return active;
}
//被安装过
- (BOOL)hasBeenInstalled {
    return (self.layoutConstraint != nil) && [self isActive];
}

//设置第二个视图属性
- (void)setSecondViewAttribute:(id)secondViewAttribute {
    //判断为值的情况分为四种类型NSNumber / CGPoint / CGSize / MASEdgeInsets
    if ([secondViewAttribute isKindOfClass:NSValue.class]) {
        [self setLayoutConstantWithValue:secondViewAttribute];
    //判断为View的情况下 new 一个MASViewAttribute
    } else if ([secondViewAttribute isKindOfClass:MAS_VIEW.class]) {
        _secondViewAttribute = [[MASViewAttribute alloc] initWithView:secondViewAttribute layoutAttribute:self.firstViewAttribute.layoutAttribute];
    //如果直接是一个发性情况下
    } else if ([secondViewAttribute isKindOfClass:MASViewAttribute.class]) {
        MASViewAttribute *attr = secondViewAttribute;
        if (attr.layoutAttribute == NSLayoutAttributeNotAnAttribute) {
            _secondViewAttribute = [[MASViewAttribute alloc] initWithView:attr.view item:attr.item layoutAttribute:self.firstViewAttribute.layoutAttribute];;
        } else {
            _secondViewAttribute = secondViewAttribute;
        }
    } else {
        NSAssert(NO, @"attempting to add unsupported attribute: %@", secondViewAttribute);
    }
}

#pragma mark - NSLayoutConstraint multiplier proxies
//乘法比例设置
- (MASConstraint * (^)(CGFloat))multipliedBy {
    return ^id(CGFloat multiplier) {
        NSAssert(!self.hasBeenInstalled,
                 @"Cannot modify constraint multiplier after it has been installed");
        
        self.layoutMultiplier = multiplier;
        return self;
    };
}

//除法比例设置
- (MASConstraint * (^)(CGFloat))dividedBy {
    return ^id(CGFloat divider) {
        NSAssert(!self.hasBeenInstalled,
                 @"Cannot modify constraint multiplier after it has been installed");

        self.layoutMultiplier = 1.0/divider;
        return self;
    };
}

#pragma mark - MASLayoutPriority proxy
//优先级设置
- (MASConstraint * (^)(MASLayoutPriority))priority {
    return ^id(MASLayoutPriority priority) {
        NSAssert(!self.hasBeenInstalled,
                 @"Cannot modify constraint priority after it has been installed");
        
        self.layoutPriority = priority;
        return self;
    };
}

#pragma mark - NSLayoutRelation proxy
//比较两者的关系是否相等
//主要添加第二个视图属性。mas_equalTo 、 equalToWithRelation 调用了这个
//这里的对比可以对比数组关系,形成一个复合约束
- (MASConstraint * (^)(id, NSLayoutRelation))equalToWithRelation {
    return ^id(id attribute, NSLayoutRelation relation) {
        if ([attribute isKindOfClass:NSArray.class]) {
            NSAssert(!self.hasLayoutRelation, @"Redefinition of constraint relation");
            NSMutableArray *children = NSMutableArray.new;
            for (id attr in attribute) {
                MASViewConstraint *viewConstraint = [self copy];
                viewConstraint.layoutRelation = relation;
                //在数组里只添加第一视图的约束 ， 这里添加了 第二视图的属性对应关系 比如调用了mas_equalTo等其它
                viewConstraint.secondViewAttribute = attr;
                [children addObject:viewConstraint];
            }
            MASCompositeConstraint *compositeConstraint = [[MASCompositeConstraint alloc] initWithChildren:children];
            compositeConstraint.delegate = self.delegate;
            [self.delegate constraint:self shouldBeReplacedWithConstraint:compositeConstraint];
            return compositeConstraint;
        } else {
            NSAssert(!self.hasLayoutRelation || self.layoutRelation == relation && [attribute isKindOfClass:NSValue.class], @"Redefinition of constraint relation");
            self.layoutRelation = relation;
            self.secondViewAttribute = attribute;
            return self;
        }
    };
}

#pragma mark - Semantic properties
//返回自身（语义化)
- (MASConstraint *)with {
    return self;
}
//返回自身（语义化)
- (MASConstraint *)and {
    return self;
}

#pragma mark - attribute chaining
//添加一个属性
- (MASConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    NSAssert(!self.hasLayoutRelation, @"Attributes should be chained before defining the constraint relation");

    return [self.delegate constraint:self addConstraintWithLayoutAttribute:layoutAttribute];
}

#pragma mark - Animator proxy

#if TARGET_OS_MAC && !(TARGET_OS_IPHONE || TARGET_OS_TV)

- (MASConstraint *)animator {
    self.useAnimator = YES;
    return self;
}

#endif

#pragma mark - debug helpers
//调试时可以设置key值
- (MASConstraint * (^)(id))key {
    return ^id(id key) {
        self.mas_key = key;
        return self;
    };
}

#pragma mark - NSLayoutConstraint constant setters
//设置 左 上 下 右
- (void)setInsets:(MASEdgeInsets)insets {
    NSLayoutAttribute layoutAttribute = self.firstViewAttribute.layoutAttribute;
    switch (layoutAttribute) {
        case NSLayoutAttributeLeft:
        case NSLayoutAttributeLeading:
            self.layoutConstant = insets.left;
            break;
        case NSLayoutAttributeTop:
            self.layoutConstant = insets.top;
            break;
        case NSLayoutAttributeBottom:
            self.layoutConstant = -insets.bottom;
            break;
        case NSLayoutAttributeRight:
        case NSLayoutAttributeTrailing:
            self.layoutConstant = -insets.right;
            break;
        default:
            break;
    }
}
//设置边距
- (void)setInset:(CGFloat)inset {
    [self setInsets:(MASEdgeInsets){.top = inset, .left = inset, .bottom = inset, .right = inset}];
}
//设置偏移值
- (void)setOffset:(CGFloat)offset {
    self.layoutConstant = offset;
}
//设置size
- (void)setSizeOffset:(CGSize)sizeOffset {
    NSLayoutAttribute layoutAttribute = self.firstViewAttribute.layoutAttribute;
    switch (layoutAttribute) {
        case NSLayoutAttributeWidth:
            self.layoutConstant = sizeOffset.width;
            break;
        case NSLayoutAttributeHeight:
            self.layoutConstant = sizeOffset.height;
            break;
        default:
            break;
    }
}
//设置中心偏移
- (void)setCenterOffset:(CGPoint)centerOffset {
    NSLayoutAttribute layoutAttribute = self.firstViewAttribute.layoutAttribute;
    switch (layoutAttribute) {
        case NSLayoutAttributeCenterX:
            self.layoutConstant = centerOffset.x;
            break;
        case NSLayoutAttributeCenterY:
            self.layoutConstant = centerOffset.y;
            break;
        default:
            break;
    }
}

#pragma mark - MASConstraint
//安装
- (void)activate {
    [self install];
}
//卸载
- (void)deactivate {
    [self uninstall];
}

- (void)install {
    //检查是否已经安装过了
    //判断约束是否已经存在，以及是否已经处理激活状态其实就是使用状态
    if (self.hasBeenInstalled) {
        return;
    }
    //判断布局是否可以响应active这个方法的设置，判断layoutConstriant存不存在
    if ([self supportsActiveProperty] && self.layoutConstraint) {
        //iOS 6.0或者7.0调用addConstraints
        //[self.view addConstraints:@[leftConstraint, rightConstraint, topConstraint, heightConstraint]];
        //iOS 8.0以后设置active属性值 就可以去使用约束了
        self.layoutConstraint.active = YES;
        [self.firstViewAttribute.view.mas_installedConstraints addObject:self];
        return;
    }
    //获取item，获取第一个viewattribute的item也就是constraintWithItem中的item
    MAS_VIEW *firstLayoutItem = self.firstViewAttribute.item;
    //获取属性比如说NSLayoutAttributeTop
    NSLayoutAttribute firstLayoutAttribute = self.firstViewAttribute.layoutAttribute;
    //获取约束的第二个view 的item
    MAS_VIEW *secondLayoutItem = self.secondViewAttribute.item;
    //获取第二个属性
    NSLayoutAttribute secondLayoutAttribute = self.secondViewAttribute.layoutAttribute;

    
    //如果是一些没有指定对比类型默认用第一个视图的父视图作为参照物
     //判断是不是要设置的是size的约束，以及判断第二个约束的属性是不是为空如果为空，就去设置下面的属性
    // alignment attributes must have a secondViewAttribute
    // therefore we assume that is refering to superview
    // eg make.left.equalTo(@10)
    if (!self.firstViewAttribute.isSizeAttribute && !self.secondViewAttribute) {
        secondLayoutItem = self.firstViewAttribute.view.superview;
        secondLayoutAttribute = firstLayoutAttribute;
    }
    
    //创建约束容器
       //创建约束布局 self.layoutRelation就是约束关系
    MASLayoutConstraint *layoutConstraint
        = [MASLayoutConstraint constraintWithItem:firstLayoutItem
                                        attribute:firstLayoutAttribute
                                        relatedBy:self.layoutRelation
                                           toItem:secondLayoutItem
                                        attribute:secondLayoutAttribute
                                       multiplier:self.layoutMultiplier
                                         constant:self.layoutConstant];
    
    //约束优先级
    layoutConstraint.priority = self.layoutPriority;
    //唯一标识
    /*
    当约束冲突发生的时候，我们可以设置view的key来定位是哪个view
    redView.mas_key = @"redView";
    greenView.mas_key = @"greenView";
    blueView.mas_key = @"blueView";
    若是觉得这样一个个设置比较繁琐，怎么办呢，Masonry则提供了批量设置的宏MASAttachKeys
    MASAttachKeys(redView,greenView,blueView); //一句代码即可全部设置
    */
    layoutConstraint.mas_key = self.mas_key;
    
    //如果第二属性的视图存在，找到共同的父类视图，赋给安装视图
    if (self.secondViewAttribute.view) {
        MAS_VIEW *closestCommonSuperview = [self.firstViewAttribute.view mas_closestCommonSuperview:self.secondViewAttribute.view];
        NSAssert(closestCommonSuperview,
                 @"couldn't find a common superview for %@ and %@",
                 self.firstViewAttribute.view, self.secondViewAttribute.view);
        self.installedView = closestCommonSuperview;
    //如果第一属性的宽度和高度被设置了，直接用第一视图
    } else if (self.firstViewAttribute.isSizeAttribute) {
        self.installedView = self.firstViewAttribute.view;
    //其它情况都用第一视图的立父视图
    } else {
        self.installedView = self.firstViewAttribute.view.superview;
    }


    MASLayoutConstraint *existingConstraint = nil;
    //如果是更新操作，检查 遍历被安装视图里是否已存在相同性操作，如果存在覆盖更新
     //判断是否是更新约束，这里判断的条件就是是否只存在constant不一样的视图
    if (self.updateExisting) {
        existingConstraint = [self layoutConstraintSimilarTo:layoutConstraint];
    }
    
    //如果存在约束直接赋值更新。
     //如果已经存在只有constant不一样的约束，就去更新constant
    if (existingConstraint) {
        // just update the constant
        existingConstraint.constant = layoutConstraint.constant;
        self.layoutConstraint = existingConstraint;
    //如果不存在约束添加到第一项约束里。
        //如果没有存在的只有constant不一样的约束，就去添加约束
    } else {
        [self.installedView addConstraint:layoutConstraint];
        self.layoutConstraint = layoutConstraint;
        [firstLayoutItem.mas_installedConstraints addObject:self];
    }
}

- (MASLayoutConstraint *)layoutConstraintSimilarTo:(MASLayoutConstraint *)layoutConstraint {
    // check if any constraints are the same apart from the only mutable property constant

    // go through constraints in reverse as we do not want to match auto-resizing or interface builder constraints
    // and they are likely to be added first.
    //从后面往前面遍历这个数组
    for (NSLayoutConstraint *existingConstraint in self.installedView.constraints.reverseObjectEnumerator) {
        if (![existingConstraint isKindOfClass:MASLayoutConstraint.class]) continue;
        if (existingConstraint.firstItem != layoutConstraint.firstItem) continue;
        if (existingConstraint.secondItem != layoutConstraint.secondItem) continue;
        if (existingConstraint.firstAttribute != layoutConstraint.firstAttribute) continue;
        if (existingConstraint.secondAttribute != layoutConstraint.secondAttribute) continue;
        if (existingConstraint.relation != layoutConstraint.relation) continue;
        if (existingConstraint.multiplier != layoutConstraint.multiplier) continue;
        if (existingConstraint.priority != layoutConstraint.priority) continue;

        return (id)existingConstraint;
    }
    return nil;
}

- (void)uninstall {
    //如果提供激活属性
    if ([self supportsActiveProperty]) {
        //设置约束不可用
        self.layoutConstraint.active = NO;
        //移除约束
        [self.firstViewAttribute.view.mas_installedConstraints removeObject:self];
        return;
    }
     //来到下面表示不能响应active方法，做了适配
    [self.installedView removeConstraint:self.layoutConstraint];
    self.layoutConstraint = nil;
    self.installedView = nil;
    
    [self.firstViewAttribute.view.mas_installedConstraints removeObject:self];
}

@end
