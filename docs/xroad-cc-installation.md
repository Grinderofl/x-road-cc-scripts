# X-Road Central Server Installation

## ARM Template

`./arm/template.json`

## ARM Template Parameters

`./arm/parameters.json`

## Installation Script

`./scripts/install_xroad.sh`

##Installation Script Conventions 

### Variables

Referred to by Reference Data Paragraphs in lower case, removing dashes (-) and substituting periods (.) with underscores (_). Multiple variables in a Reference Data paragraph are separated by additional two underscores (__) in sequence.

**Example:**

```
# Test Guide for Test Server Reference Data

# [TG-TS] 1.1	Test Variable One
tgts1_1='var1'
# [TG-TS] 1.2	Test Variable Two
tgts1_2='var2'
# [TG-TS] 1.2.1 Test Variable Three
tgts1_2_1='var3'
# [TG-TS] 1.3   Test Variable Group
#	.1	Variable Four
tgts1_3__1='var4'
#   .2	Variable Five
tgts1_3__2='var5'
```

## Links

[IG-CS] https://github.com/nordic-institute/X-Road/blob/develop/doc/Manuals/ig-cs_x-road_6_central_server_installation_guide.md 

[UG-CS] <https://github.com/nordic-institute/X-Road/blob/develop/doc/Manuals/ug-cs_x-road_6_central_server_user_guide.md 

