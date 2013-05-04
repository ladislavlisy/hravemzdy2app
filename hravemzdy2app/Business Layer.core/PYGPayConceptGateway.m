//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGPayConceptGateway.h"
#import "PYGUnknownConcept.h"
#import "PYGSymbolConcepts.h"
#import "NSString+RubyCocoaString.h"
#import "NSDictionary+Func.h"
#import "PYGPayrollTag.h"
#import "NSArray+Func.h"
#import <objc/message.h>

#define PYGConceptClassAssert(condition, className, codeName) NSCAssert2((condition), @"Concept Class not implemented: %s for: %s", (className), (codeName))

@implementation PYGPayConceptGateway {

}

- (id)init {
    if (!(self=[super init])) return nil;
    models = [NSMutableDictionary dictionaryWithObjectsAndKeys:[PYGUnknownConcept concept], @(CONCEPT_UNKNOWN), nil];
    return self;
}

- (PYGPayrollConcept *)conceptFor:(NSUInteger)tagCode conceptName:(NSString *)conceptCodeName andValues:(NSDictionary *)values {
    NSString * conceptClass = [self classNameFor:conceptCodeName];
    id conceptAllocate = [NSClassFromString(conceptClass) alloc];
    PYGPayrollConcept * conceptInstance = (PYGPayrollConcept *)objc_msgSend(conceptAllocate,
            @selector(initWithTagCode:andValues:), tagCode, values);
    PYGConceptClassAssert(conceptInstance != nil, [conceptClass UTF8String], [conceptCodeName UTF8String]);
    return conceptInstance;
}

- (NSString *)classNameFor:(NSString *)conceptCodeName {
    NSRegularExpression * conceptRegex = [NSRegularExpression regularExpressionWithPattern:@"CONCEPT_(.*)" options:0 error:NULL];
    NSTextCheckingResult * regexMatch = [conceptRegex firstMatchInString:conceptCodeName options:0 range:NSMakeRange(0, [conceptCodeName length])];
    NSString * conceptClass = [conceptCodeName substringWithRange:[regexMatch rangeAtIndex:1]];
    NSString * className = [[[conceptClass underscore] camelize] concat:@"Concept"];
    return [@"PYG" concat:className];
}

- (PYGPayrollConcept *)conceptFromModels:(PYGPayrollTag *)termTag {
    PYGPayrollConcept * baseConcept = nil;
    if ((baseConcept=[models objectForKey:@(termTag.conceptCode)])==nil)
    {
        baseConcept = [self emptyConceptFor:termTag];
        [models setObject:baseConcept forKey:@(termTag.conceptCode)];
    }
    return baseConcept;
}

- (PYGPayrollConcept *)findConcept:(NSUInteger)conceptCode {
    PYGPayrollConcept * baseConcept = nil;
    if ((baseConcept=[models objectForKey:@(conceptCode)])==nil)
    {
        baseConcept = [models objectForKey:@(CONCEPT_UNKNOWN)];
    }
    return baseConcept;

}

- (PYGPayrollConcept *)emptyConceptFor:(PYGPayrollTag *)termTag {
    NSDictionary * emptyValues = @{};
    PYGPayrollConcept * emptyConcept = [self conceptFor:termTag.code conceptName:[termTag conceptName] andValues:emptyValues];
    NSArray * emptyPending = [self recPendingCodes:[emptyConcept pendingCodes]];
    [emptyConcept setPendingCodes:emptyPending];

    return emptyConcept;
}

- (NSArray *)collectPendingCodesFor:(NSDictionary *)termDict {
    NSDictionary * termsForPending = termDict;

    NSArray * pending = [termsForPending injectForArray:@[] with:^NSArray * (NSArray * agr, id termKey, id termObj) {
        PYGPayrollConcept * termConcept = termObj;
        NSArray * termPendingCodes = [termConcept tagPendingCodes];
        if (termPendingCodes == nil) {
            return [NSArray arrayWithArray:agr];
        }
        else
        {
            return [agr arrayByAddingObjectsFromArray:termPendingCodes];
        }
    }];
    NSArray * pendingUnique = [[NSSet setWithArray:pending] allObjects];
    return pendingUnique;

}

- (NSArray *)recPendingCodes:(NSArray *)pendingCodes {
    NSArray * retCodes = [pendingCodes injectForArray:[pendingCodes copy] with:^(NSArray * agr, id tag, NSUInteger index) {
        PYGPayrollTag * tagRefer = (PYGPayrollTag *)tag;
        NSArray * pendingCodesForTag = [self pendingCodesForTagCode:tagRefer];
        return [agr arrayByAddingObjectsFromArray:pendingCodesForTag];
    }];
    NSArray * retCodesUnique = [[NSSet setWithArray:retCodes] allObjects];
    return retCodesUnique;
}

- (NSArray *)pendingCodesForTagCode:(PYGPayrollTag *)tagRefer {
    PYGPayrollConcept * baseConcept = [self conceptFromModels:tagRefer];
    if (baseConcept.tagPendingCodes == nil) {
        return [self recPendingCodes:[baseConcept pendingCodes]];
    }
    else
    {
        return baseConcept.tagPendingCodes;
    }
}

@end