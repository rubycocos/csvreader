# Humanitarian eXchangle Language (HXL) Attributes

[`+abducted`](#abducted)
[`+activity`](#activity)
[`+adolescents`](#adolescents)
[`+adults`](#adults)
[`+approved`](#approved)
[`+bounds`](#bounds)
[`+canceled`](#canceled)
[`+children`](#children)
[`+cluster`](#cluster)
[`+code`](#code)
[`+converted`](#converted)
[`+coord`](#coord)
[`+dest`](#dest)
[`+displaced`](#displaced)
[`+elderly`](#elderly)
[`+elevation`](#elevation)
[`+email`](#email)
[`+end`](#end)
[`+f`](#f)
[`+funder`](#funder)
[`+hh`](#hh)
[`+i`](#i)
[`+id`](#id)
[`+idps`](#idps)
[`+impl`](#impl)
[`+incamp`](#incamp)
[`+ind`](#ind)
[`+infants`](#infants)
[`+infected`](#infected)
[`+injured`](#injured)
[`+killed`](#killed)
[`+label`](#label)
[`+lat`](#lat)
[`+lon`](#lon)
[`+m`](#m)
[`+name`](#name)
[`+noncamp`](#noncamp)
[`+num`](#num)
[`+occurred`](#occurred)
[`+origin`](#origin)
[`+phone`](#phone)
[`+prog`](#prog)
[`+programme`](#programme)
[`+project`](#project)
[`+provided`](#provided)
[`+refugees`](#refugees)
[`+reported`](#reported)
[`+source`](#source)
[`+start`](#start)
[`+text`](#text)
[`+type`](#type)
[`+url`](#url)
[`+used`](#used)


## (1) Sex- and-age disaggregation (SADD) attributes

### `+adolescents`

Adolescents, loosely defined (precise age range varies); may overlap [`+children`](#children) and [`+adult`](#adult). You can optionally create custom attributes in addition to this to add precise age ranges, e.g. "[`+adolescents`](#adolescents) `+age12_17`". _Since version 1.0_

Tags: [`#affected`](TAGS.md#affected) [`#inneed`](TAGS.md#inneed) [`#population`](TAGS.md#population) [`#reached`](TAGS.md#reached) [`#targeted`](TAGS.md#targeted)

### `+adults`

Adults, loosely defined (precise age range varies); may overlap [`+adolescents`](#adolescents) and [`+elderly`](#elderly). You can optionally create custom attributes in addition to this to add precise age ranges, e.g. "[`+adults`](#adults) `+age18_64`". _Since version 1.0_

Tags: [`#affected`](TAGS.md#affected) [`#inneed`](TAGS.md#inneed) [`#population`](TAGS.md#population) [`#reached`](TAGS.md#reached) [`#targeted`](TAGS.md#targeted)

### `+children`

The associated hashtag applies to non-adults, loosely defined (precise age range varies; may overlap [`+infants`](#infants) and [`+adolescents`](#adolescents)). You can optionally create custom attributes in addition to this to add precise age ranges, e.g. "[`+children`](#children) `+age3_11`". _Since version 1.0_

Tags: [`#affected`](TAGS.md#affected) [`#inneed`](TAGS.md#inneed) [`#population`](TAGS.md#population) [`#reached`](TAGS.md#reached) [`#targeted`](TAGS.md#targeted)

### `+elderly`

Elderly people, loosely defined (precise age range varies). May overlap [`+adults`](#adults). You can optionally create custom attributes in addition to this to add precise age ranges, e.g. "[`+elderly`](#elderly) [`+age65plus`](#age65plus)". _Since version 1.0_

Tags: [`#affected`](TAGS.md#affected) [`#inneed`](TAGS.md#inneed) [`#population`](TAGS.md#population) [`#reached`](TAGS.md#reached) [`#targeted`](TAGS.md#targeted)

### `+f`

Female people. See also [`+m`](#m) and [`+i`](#i). _Since version 1.0_

Tags: [`#affected`](TAGS.md#affected) [`#inneed`](TAGS.md#inneed) [`#population`](TAGS.md#population) [`#reached`](TAGS.md#reached) [`#targeted`](TAGS.md#targeted)

### `+hh`

Households (vs [`+ind`](#ind) for individual people). The exact definition of "household" may vary among aid organisations. _Since version 1.1_

Tags: [`#affected`](TAGS.md#affected) [`#inneed`](TAGS.md#inneed) [`#population`](TAGS.md#population) [`#reached`](TAGS.md#reached) [`#targeted`](TAGS.md#targeted)

### `+i`

Intersex or non-gender-binary people. Use this attribute for any groups who do not identify as male ([`+m`](#m)) or female ([`+f`](#f)). _Since version 1.0_

Tags: [`#affected`](TAGS.md#affected) [`#inneed`](TAGS.md#inneed) [`#population`](TAGS.md#population) [`#reached`](TAGS.md#reached) [`#targeted`](TAGS.md#targeted)

### `+ind`

Individual people (vs [`+hh`](#hh) for households). _Since version 1.1_

Tags: [`#affected`](TAGS.md#affected) [`#inneed`](TAGS.md#inneed) [`#population`](TAGS.md#population) [`#reached`](TAGS.md#reached) [`#targeted`](TAGS.md#targeted)

### `+infants`

Infant children, loosely defined (precise age range varies; may overlap [`+children`](#children)). You can optionally create custom attributes in addition to this to add precise age ranges, e.g. "[`+infants`](#infants) `+age0_2`". _Since version 1.0_

Tags: [`#affected`](TAGS.md#affected) [`#inneed`](TAGS.md#inneed) [`#population`](TAGS.md#population) [`#reached`](TAGS.md#reached) [`#targeted`](TAGS.md#targeted)

### `+m`

Male people. See also [`+f`](#f) and [`+i`](#i). _Since version 1.0_

Tags: [`#affected`](TAGS.md#affected) [`#inneed`](TAGS.md#inneed) [`#population`](TAGS.md#population) [`#reached`](TAGS.md#reached) [`#targeted`](TAGS.md#targeted)

## (2) Organisation and activity attributes

### `+activity`

The implementers classify this activity as an "activity" proper (may imply different hierarchical levels in different contexts). _Since version 1.1_

Tags: [`#activity`](TAGS.md#activity)

### `+cluster`

Identifies a sector as a formal IASC humanitarian cluster. _Since version 1.1_

Tags: [`#sector`](TAGS.md#sector)

### `+funder`

Funding org/agency (e.g. donor). _Since version 1.0_

Tags: [`#org`](TAGS.md#org)

### `+impl`

Implementing partner. _Since version 1.0_

Tags: [`#org`](TAGS.md#org)

### `+prog`

Programming org/agency. _Since version 1.0_

Tags: [`#org`](TAGS.md#org)

### `+programme`

The implementers classify this activity as a "programme" (may imply different hierarchical levels in different contexts). _Since version 1.1_

Tags: [`#activity`](TAGS.md#activity)

### `+project`

The implementers classify this activity as a "project" (may imply different hierarchical levels in different contexts). _Since version 1.1_

Tags: [`#activity`](TAGS.md#activity)

### `+provided`

Refers to a #service, #item, etc. that has been provided to people in need. _Since version 1.1_

Tags: [`#item`](TAGS.md#item) [`#service`](TAGS.md#service)

### `+used`

Refers to a #service, #item, etc. that affected people have actually consumed or otherwise taken advantage of. _Since version 1.1_

Tags: [`#item`](TAGS.md#item) [`#service`](TAGS.md#service)

## (3) Classification attributes

### `+code`

A unique, machine-readable code. _Since version 1.0_

Tags: [`#activity`](TAGS.md#activity) [`#adm1`](TAGS.md#adm1) [`#adm2`](TAGS.md#adm2) [`#adm3`](TAGS.md#adm3) [`#adm4`](TAGS.md#adm4) [`#adm5`](TAGS.md#adm5) [`#beneficiary`](TAGS.md#beneficiary) [`#cause`](TAGS.md#cause) [`#channel`](TAGS.md#channel) [`#country`](TAGS.md#country) [`#crisis`](TAGS.md#crisis) [`#currency`](TAGS.md#currency) [`#event`](TAGS.md#event) [`#group`](TAGS.md#group) [`#impact`](TAGS.md#impact) [`#indicator`](TAGS.md#indicator) [`#item`](TAGS.md#item) [`#loc`](TAGS.md#loc) [`#modality`](TAGS.md#modality) [`#need`](TAGS.md#need) [`#org`](TAGS.md#org) [`#output`](TAGS.md#output) [`#region`](TAGS.md#region) [`#sector`](TAGS.md#sector) [`#service`](TAGS.md#service) [`#severity`](TAGS.md#severity) [`#status`](TAGS.md#status) [`#subsector`](TAGS.md#subsector)

### `+type`

Types or categories. Use with #org, #loc, #indicator, etc to provide classification information. _Since version 1.0_

Tags: [`#access`](TAGS.md#access) [`#activity`](TAGS.md#activity) [`#beneficiary`](TAGS.md#beneficiary) [`#capacity`](TAGS.md#capacity) [`#cause`](TAGS.md#cause) [`#contact`](TAGS.md#contact) [`#crisis`](TAGS.md#crisis) [`#description`](TAGS.md#description) [`#event`](TAGS.md#event) [`#frequency`](TAGS.md#frequency) [`#group`](TAGS.md#group) [`#impact`](TAGS.md#impact) [`#indicator`](TAGS.md#indicator) [`#item`](TAGS.md#item) [`#loc`](TAGS.md#loc) [`#need`](TAGS.md#need) [`#operations`](TAGS.md#operations) [`#org`](TAGS.md#org) [`#output`](TAGS.md#output) [`#sector`](TAGS.md#sector) [`#service`](TAGS.md#service) [`#severity`](TAGS.md#severity) [`#subsector`](TAGS.md#subsector)

## (4) Geographical attributes

### `+bounds`

Boundary data (e.g. inline GeoJSON). _Since version 1.0_

Tags: [`#geo`](TAGS.md#geo)

### `+coord`

Geodetic coordinates (lat[`+lon`](#lon) together). _Since version 1.0_

Tags: [`#geo`](TAGS.md#geo)

### `+dest`

Place of destination (intended or actual). _Since version 1.1_

Tags: [`#adm1`](TAGS.md#adm1) [`#adm2`](TAGS.md#adm2) [`#adm3`](TAGS.md#adm3) [`#adm4`](TAGS.md#adm4) [`#adm5`](TAGS.md#adm5) [`#country`](TAGS.md#country) [`#loc`](TAGS.md#loc) [`#region`](TAGS.md#region)

### `+elevation`

Elevation above sea level (usually metres). _Since version 1.0_

Tags: [`#geo`](TAGS.md#geo)

### `+lat`

Latitude (decimal degrees preferred). _Since version 1.0_

Tags: [`#geo`](TAGS.md#geo)

### `+lon`

Longitude (decimal degrees preferred). _Since version 1.0_

Tags: [`#geo`](TAGS.md#geo)

### `+origin`

The data describes places of origin (intended or actual), e.g. the country of origin for displaced people. _Since version 1.1_

Tags: [`#adm1`](TAGS.md#adm1) [`#adm2`](TAGS.md#adm2) [`#adm3`](TAGS.md#adm3) [`#adm4`](TAGS.md#adm4) [`#adm5`](TAGS.md#adm5) [`#country`](TAGS.md#country) [`#loc`](TAGS.md#loc) [`#region`](TAGS.md#region)

## (5) Date attributes

### `+approved`

Date or time when something was approved. _Since version 1.0_

Tags: [`#date`](TAGS.md#date)

### `+canceled`

Date or time when something (e.g. an #activity) was canceled. _Since version 1.0_

Tags: [`#date`](TAGS.md#date)

### `+converted`

Date or time used for converting a monetary value to another currency. _Since version 1.1_

Tags: [`#date`](TAGS.md#date)

### `+end`

Date or time when something finished or will finish. _Since version 1.0_

Tags: [`#date`](TAGS.md#date)

### `+occurred`

Date or time when something took place. _Since version 1.0_

Tags: [`#date`](TAGS.md#date)

### `+reported`

Date or time when the information was reported. _Since version 1.0_

Tags: [`#date`](TAGS.md#date)

### `+start`

Date or time when something started or will start. _Since version 1.0_

Tags: [`#date`](TAGS.md#date)

## (6) Impact attributes

### `+abducted`

Hashtag refers to people who have been abducted. _Since version 1.1_

Tags: [`#affected`](TAGS.md#affected) [`#inneed`](TAGS.md#inneed) [`#reached`](TAGS.md#reached) [`#targeted`](TAGS.md#targeted)

### `+displaced`

Displaced people or households. Refers to all types of displacement: use [`+idps`](#idps) or [`+refugees`](#refugees) to be more specific. _Since version 1.0_

Tags: [`#affected`](TAGS.md#affected) [`#inneed`](TAGS.md#inneed) [`#population`](TAGS.md#population) [`#reached`](TAGS.md#reached) [`#targeted`](TAGS.md#targeted)

### `+idps`

Internally-displaced people or households. More specific than [`+displaced`](#displaced). _Since version 1.0_

Tags: [`#affected`](TAGS.md#affected) [`#inneed`](TAGS.md#inneed) [`#population`](TAGS.md#population) [`#reached`](TAGS.md#reached) [`#targeted`](TAGS.md#targeted)

### `+incamp`

Located in camps. _Since version 1.0_

Tags: [`#affected`](TAGS.md#affected) [`#inneed`](TAGS.md#inneed) [`#population`](TAGS.md#population) [`#reached`](TAGS.md#reached) [`#targeted`](TAGS.md#targeted)

### `+infected`

People infected with a disease. _Since version 1.0_

Tags: [`#affected`](TAGS.md#affected) [`#inneed`](TAGS.md#inneed) [`#reached`](TAGS.md#reached) [`#targeted`](TAGS.md#targeted)

### `+injured`

People injured. _Since version 1.0_

Tags: [`#affected`](TAGS.md#affected) [`#inneed`](TAGS.md#inneed) [`#reached`](TAGS.md#reached) [`#targeted`](TAGS.md#targeted)

### `+killed`

People killed. _Since version 1.0_

Tags: [`#affected`](TAGS.md#affected)

### `+noncamp`

Not located in camps. _Since version 1.0_

Tags: [`#affected`](TAGS.md#affected) [`#inneed`](TAGS.md#inneed) [`#population`](TAGS.md#population) [`#reached`](TAGS.md#reached) [`#targeted`](TAGS.md#targeted)

### `+refugees`

Refugee people or households. More specific than [`+displaced`](#displaced). _Since version 1.0_

Tags: [`#affected`](TAGS.md#affected) [`#inneed`](TAGS.md#inneed) [`#population`](TAGS.md#population) [`#reached`](TAGS.md#reached) [`#targeted`](TAGS.md#targeted)

## (7) General attributes

### `+email`

Email address. _Since version 1.0_

Tags: [`#contact`](TAGS.md#contact)

### `+id`

Use with #meta to provide internal identifiers for data records. _Since version 1.1_

Tags: [`#meta`](TAGS.md#meta)

### `+label`

Text labels (for a table or chart). _Since version 1.0_

### `+name`

Human-readable name, title, or label. _Since version 1.0_

Tags: [`#activity`](TAGS.md#activity) [`#adm1`](TAGS.md#adm1) [`#adm2`](TAGS.md#adm2) [`#adm3`](TAGS.md#adm3) [`#adm4`](TAGS.md#adm4) [`#adm5`](TAGS.md#adm5) [`#beneficiary`](TAGS.md#beneficiary) [`#cause`](TAGS.md#cause) [`#channel`](TAGS.md#channel) [`#contact`](TAGS.md#contact) [`#country`](TAGS.md#country) [`#crisis`](TAGS.md#crisis) [`#event`](TAGS.md#event) [`#group`](TAGS.md#group) [`#impact`](TAGS.md#impact) [`#indicator`](TAGS.md#indicator) [`#item`](TAGS.md#item) [`#loc`](TAGS.md#loc) [`#modality`](TAGS.md#modality) [`#need`](TAGS.md#need) [`#org`](TAGS.md#org) [`#output`](TAGS.md#output) [`#region`](TAGS.md#region) [`#sector`](TAGS.md#sector) [`#service`](TAGS.md#service) [`#severity`](TAGS.md#severity) [`#status`](TAGS.md#status) [`#subsector`](TAGS.md#subsector)

### `+num`

The data consists of quantitative, numeric information. _Since version 1.0_

Tags: [`#capacity`](TAGS.md#capacity) [`#indicator`](TAGS.md#indicator) [`#output`](TAGS.md#output)

### `+phone`

The data consists of #contact phone numbers. _Since version 1.0_

Tags: [`#contact`](TAGS.md#contact)

### `+source`

Information source for the data in the row or record. _Since version 1.0_

Tags: [`#meta`](TAGS.md#meta)

### `+text`

The data consists of qualitative, narrative textual information. _Since version 1.0_

Tags: [`#indicator`](TAGS.md#indicator)

### `+url`

The data consists of web links related to the main hashtag (e.g. for an #org, #service, #activity, #loc, etc). _Since version 1.0_

Tags: [`#activity`](TAGS.md#activity) [`#contact`](TAGS.md#contact) [`#meta`](TAGS.md#meta) [`#org`](TAGS.md#org) [`#service`](TAGS.md#service)

