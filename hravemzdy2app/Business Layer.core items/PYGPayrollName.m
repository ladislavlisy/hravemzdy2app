//
// Created by lisy on 31.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGPayrollName.h"
#import "NSDictionary+Func.h"

static const NSString * VGRP_POS = @"vgrp_pos";
static const NSString * HGRP_POS = @"hgrp_pos";

@implementation PYGPayrollName {
	NSDictionary *xmlGroups;
}

@synthesize title = _title;
@synthesize description = _description;

-(id)initWithCodeRefer:(PYGCodeNameRefer*)tagRefer andTitle:(NSString*)title andDescription:(NSString*)description andVertGroup:(NSString*)vertGroup andHorizGroup:(NSString*)horizGroup {
    if (!(self=[super initWithCode:tagRefer.code andName:tagRefer.name])) return nil;
    _title = [NSString stringWithString:title];
    _description = [NSString stringWithString:description];
    xmlGroups = @{};
	if (vertGroup != nil) {
		xmlGroups = [xmlGroups merge:@{VGRP_POS : vertGroup}];
	}
	if (horizGroup != nil) {
        xmlGroups = [xmlGroups merge:@{HGRP_POS : horizGroup}];
	}
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

- (NSDictionary *)getGroups {
    return xmlGroups;
}

- (bool)isMatchVGroup:(NSString *)group_code {
    return [xmlGroups[VGRP_POS] isEqual:group_code];
}

- (bool)isMatchHGroup:(NSString *)group_code {
    return [xmlGroups[HGRP_POS] isEqual:group_code];
}

@end