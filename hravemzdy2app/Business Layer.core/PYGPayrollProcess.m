//
// Created by lisy on 11.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGPayrollProcess.h"
#import "PYGPayrollPeriod.h"
#import "PYGPayTagGateway.h"
#import "PYGPayConceptGateway.h"
#import "PYGTagRefer.h"
#import "PYGCodeNameRefer.h"
#import "PYGPayrollConcept.h"
#import "NSArray+Func.h"
#import "NSDictionary+Func.h"
#import "PYGPayrollTag.h"


@implementation PYGPayrollProcess {

@private
    NSMutableDictionary *terms;
    NSDictionary *results;
}

- (id)initWithPeriodCode:(NSUInteger)code andTags:(PYGPayTagGateway *)payTags andConcepts:(PYGPayConceptGateway *) payConcepts {
    if (!(self=[super init])) return nil;
    _period = [PYGPayrollPeriod payrollPeriodWithCode:code];
    _tags = payTags;
    _concepts = payConcepts;
    terms = [[NSMutableDictionary alloc] init];
    results = [[NSDictionary alloc] init];
    return self;
}

- (id)initWithPeriodYear:(NSUInteger)year andMonth:(Byte)month andTags:(PYGPayTagGateway *)payTags andConcepts:(PYGPayConceptGateway *) payConcepts {
    return [self initWithPeriodCode:(year*100 + month) andTags:payTags andConcepts:payConcepts];
}

+ (PYGPayrollProcess *)payrollProcessWithPeriodCode:(NSUInteger)code andTags:(PYGPayTagGateway *)payTags andConcepts:(PYGPayConceptGateway *) payConcepts {
    return [[self alloc] initWithPeriodCode:code andTags:payTags andConcepts:payConcepts];
}

+ (PYGPayrollProcess *)payrollProcessWithPeriodYear:(NSUInteger)year andMonth:(Byte)month andTags:(PYGPayTagGateway *)payTags andConcepts:(PYGPayConceptGateway *) payConcepts {
    return [[self alloc] initWithPeriodYear:year andMonth:month  andTags:payTags andConcepts:payConcepts];
}

- (PYGPayrollTag *)findTag:(NSUInteger)tagCode {
    return [self.tags findTag:tagCode];
}

- (PYGPayrollConcept *)findConcept:(NSUInteger)conceptCode {
    return [self.concepts findConcept:conceptCode];
}

// Insert item to terms dictionary
- (PYGTagRefer*)insTermPeriodBase:(NSUInteger)tagBase tagRef:(PYGCodeNameRefer *)tagCodeRef tagOrder:(NSUInteger)tagCodeOrder andValues:(NSDictionary *)values {
    return [self insTermToHash:terms periodBase:tagBase tagRef:tagCodeRef tagOrder:tagCodeOrder andValues:values];
}

// Add item to terms dictionary
- (PYGTagRefer*)addTermTagRef:(PYGCodeNameRefer *)tagCodeRef andValues:(NSDictionary *)values {
    NSUInteger tagBase = PERIOD_NOW;
    return [self addTermToHash:terms periodBase:tagBase tagRef:tagCodeRef andValues:values];
}

//TODO: addTermTagRef: andValues: asTimes:
- (void)addTermTagRef:(PYGCodeNameRefer *)tagCodeRef andValues:(NSDictionary *)values asTimes:(NSUInteger)count{
    NSUInteger tagBase = PERIOD_NOW;
    for (int i = 0; i < count; i++) {
        [self addTermToHash:terms periodBase:tagBase tagRef:tagCodeRef andValues:values];
    }
}

- (NSDictionary *)getTerm:(PYGTagRefer *)payTag {
    PYGTagRefer * compTag = payTag;
    NSDictionary * selTerms = [terms selectWithBlock:^BOOL(id key, id obj) {
        PYGTagRefer *tagRefer = (PYGTagRefer *) key;
        return ([tagRefer isEqual:compTag]);
    }];
    return selTerms;
}

-(NSDictionary *)getResults {
    return [NSDictionary dictionaryWithDictionary:results];
}

- (NSDictionary *)getResult:(PYGTagRefer *)payTag {
    PYGTagRefer * compTag = payTag;
    NSDictionary * selResults = [results selectWithBlock:^BOOL(id key, id obj) {
        PYGTagRefer *tagRefer = (PYGTagRefer *) key;
        return ([tagRefer isEqual:compTag]);
    }];
    return selResults;
}

- (NSDictionary *)evaluate:(PYGTagRefer *)payTag {
    NSUInteger periodBase = PERIOD_NOW;
    NSArray * pendingUniqCodes = [self.concepts collectPendingCodesFor:terms];

    NSDictionary * calculationSteps = [self createCalculationSteps:terms withPeriodBase:periodBase forPending:pendingUniqCodes];

    results = [calculationSteps injectForDict:(@{}) sorted:@selector(compare:)
                                          with:^NSDictionary * (NSDictionary * agr, id key, id obj) {
        PYGPayrollConcept * objConcept = (PYGPayrollConcept *)obj;
        return [agr merge:@{key : [objConcept evaluateForPeriod:self.period config:self.tags results:agr]}];
    }];
    return [self getResult:payTag];
}

// methods for insert and add
- (PYGTagRefer*)insTermToHash:(NSMutableDictionary*)termHash periodBase:(NSUInteger)tagBase tagRef:(PYGCodeNameRefer *)tagCodeRef tagOrder:(NSUInteger)tagCodeOrder andValues:(NSDictionary *)values {
    NSDictionary * termToInsert = [self newTermPairWithPeriodBase:tagBase tagRef:tagCodeRef tagOrder:tagCodeOrder andValues:values];
    [termHash addEntriesFromDictionary:termToInsert];
    return [self getFirstFromKeyFromTerms:termToInsert];
}

- (PYGTagRefer*)addTermToHash:(NSMutableDictionary*)termHash periodBase:(NSUInteger)tagBase tagRef:(PYGCodeNameRefer *)tagCodeRef andValues:(NSDictionary *)values {
    NSDictionary * termToAdd = [self newTermPairWithTermHash:termHash andPeriodBase:tagBase tagRef:tagCodeRef andValues:values];
    [termHash addEntriesFromDictionary:termToAdd];
    return [self getFirstFromKeyFromTerms:termToAdd];
}

- (NSDictionary*)newTermPairWithTermHash:(NSMutableDictionary*)termHash andPeriodBase:(NSUInteger)tagBase tagRef:(PYGCodeNameRefer *)tagCodeRef andValues:(NSDictionary *)values {
    NSUInteger newCodeOrder = [self getNewTagOrderFrom:termHash withPeriodBase:tagBase tagCode:tagCodeRef.code];
    PYGTagRefer* termKey = [self newTermKeyWithPeriodBase:tagBase tagRef:tagCodeRef tagOrder:newCodeOrder];
    PYGPayrollConcept * termConcept = [self newTermConcept:tagCodeRef andValues:values];
    return [NSDictionary dictionaryWithObjectsAndKeys:termConcept, termKey, nil];
}

- (PYGTagRefer*)newTermKeyWithPeriodBase:(NSUInteger)tagBase tagRef:(PYGCodeNameRefer *)tagCodeRef tagOrder:(NSUInteger)tagCodeOrder {
    return [PYGTagRefer tagReferWithPeriodBase:tagBase andCode:[tagCodeRef code] andCodeOrder:tagCodeOrder];
}

- (NSUInteger)getNewTagOrderFrom:(NSMutableDictionary*)termHash withPeriodBase:(NSUInteger)tagBase tagCode:(NSUInteger)code {
    return [self getNewTagOrderInArray:termHash.allKeys withPeriodBase:tagBase tagCode:code];
}

- (NSUInteger)getNewTagOrderInArray:(NSArray*)keysArray withPeriodBase:(NSUInteger)tagBase tagCode:(NSUInteger)code {
    NSArray * selectedTags = [self selectTags:keysArray ForBase:tagBase andCode:code];
    NSMutableArray * mappedOrders = [self mapTagsToCodeOrders:selectedTags];
    [mappedOrders sortUsingComparator:^NSComparisonResult(id a, id b) {
        NSNumber *first = (NSNumber*)a;
        NSNumber *second = (NSNumber*)b;
        return [first compare:second];
    }];
    return [self getNewOrderFrom:mappedOrders];
}

- (NSUInteger)getTagOrderFrom:(NSDictionary*)termHash withPeriodBase:(NSUInteger)tagBase tagCode:(NSUInteger)code {
    return [self getTagOrderInArray:termHash.allKeys withPeriodBase:tagBase tagCode:code];
}

- (NSUInteger)getTagOrderInArray:(NSArray*)keysArray withPeriodBase:(NSUInteger)tagBase tagCode:(NSUInteger)code {
    NSArray * selectedTags = [self selectTags:keysArray ForBase:tagBase andCode:code];
    NSMutableArray * mappedOrders = [self mapTagsToCodeOrders:selectedTags];
    [mappedOrders sortUsingComparator:^NSComparisonResult(id a, id b) {
        NSNumber *first = (NSNumber*)a;
        NSNumber *second = (NSNumber*)b;
        return [first compare:second];
    }];
    return [self getFirstOrderFrom:mappedOrders];
}

- (NSArray *)selectTags:(NSArray*)keysArray ForBase:(NSUInteger)tagBase andCode:(NSUInteger)code {
    NSUInteger predicateBase = tagBase;
    NSUInteger predicateCode = code;

    NSPredicate * equalBaseAndCodePredicate = [NSPredicate predicateWithBlock:^BOOL (id obj, NSDictionary *bind) {
        PYGTagRefer * tagRefer = (PYGTagRefer *)obj;
        return ([tagRefer periodBase]==predicateBase && [tagRefer code]==predicateCode);
    }];
    return [keysArray filteredArrayUsingPredicate:equalBaseAndCodePredicate];
}

- (NSMutableArray *)mapTagsToCodeOrders:(NSArray *)keysArray {
    return [keysArray map:^id(id obj){
        return @([(PYGTagRefer*)obj codeOrder]);
    }];
}

// TODO: modify statement (x - agr) > 1 => ((x > agr) && (x - agr) > 1)
- (NSUInteger)getNewOrderFrom:(NSArray *)ordersSorted {
    NSUInteger lastCodeOrder = [ordersSorted injectForUInteger:0 with:^NSUInteger (NSUInteger agr, NSUInteger x, NSUInteger idx){
        return ((x > agr) && (x - agr) > 1 ? agr : x);
    }];
    return (lastCodeOrder + 1);
}

- (NSUInteger)getFirstOrderFrom:(NSArray *)ordersSorted {
    NSUInteger firstCodeOrder = 1;
    if ([ordersSorted count]>0 && ordersSorted[0]!=nil) {
        firstCodeOrder = U_UNBOX(ordersSorted[0]);
    }
    return firstCodeOrder;
}

- (PYGTagRefer*)getFirstFromKeyFromTerms:(NSDictionary *)termsAdded {
    if (termsAdded.count == 0) {
        return nil;
    }
    return [termsAdded allKeys][0];
}

- (PYGPayrollConcept*) newTermConcept:(PYGCodeNameRefer *)tagCodeRef andValues:(NSDictionary *)values {
    PYGPayrollTag * termTag = [self.tags tagFromModels:tagCodeRef];
    PYGPayrollConcept * baseConcept = [self.concepts conceptFromModels:termTag];
    PYGPayrollConcept * termConcept = [baseConcept newConceptWithCode:tagCodeRef.code andValues:values];
    return termConcept;
}

// methods for evaluate
- (NSDictionary *)createCalculationSteps:(NSDictionary *) termHash withPeriodBase:(NSUInteger)periodBase forPending:(NSArray *) pendingCodes {
    NSDictionary * emptyValue = @{};
    NSDictionary * calculationSteps = [pendingCodes injectForDict:[termHash copy] with:^NSDictionary * (NSDictionary * agr, id code, NSUInteger index) {
        PYGCodeNameRefer * tagRefer = (PYGCodeNameRefer *)code;
        return [self mergeTermToHash:agr withPeriodBase:periodBase andTerm:tagRefer andValues:emptyValue];
    }];
    return calculationSteps;
}

- (NSDictionary *)mergeTermToHash:(NSDictionary *) termHash withPeriodBase:(NSUInteger)periodBase andTerm:(PYGCodeNameRefer *)termRefer andValues:(NSDictionary *)termValues {
    NSUInteger mergeCodeOrder = [self getTagOrderFrom:termHash withPeriodBase:periodBase tagCode:termRefer.code];
    NSDictionary * termToMerge = [self newTermPairWithPeriodBase:periodBase tagRef:termRefer tagOrder:mergeCodeOrder andValues:termValues];

    return [termHash merge:termToMerge withBlock:^id (id key, id objectLft, id objectRht) {
        return objectLft;
    }];
}

- (NSDictionary*) newTermPairWithPeriodBase:(NSUInteger)tagBase tagRef:(PYGCodeNameRefer *)tagCodeRef tagOrder:(NSUInteger)tagCodeOrder andValues:(NSDictionary *)values {
    PYGTagRefer* termKey = [self newTermKeyWithPeriodBase:tagBase tagRef:tagCodeRef tagOrder:tagCodeOrder];
    PYGPayrollConcept * termConcept = [self newTermConcept:tagCodeRef andValues:values];
    return [NSDictionary dictionaryWithObjectsAndKeys:termConcept, termKey, nil];
}


@end