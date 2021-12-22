# Humanitarian eXchangle Language (HXL) Tags

[`#access`](#access)
[`#activity`](#activity)
[`#adm1`](#adm1)
[`#adm2`](#adm2)
[`#adm3`](#adm3)
[`#adm4`](#adm4)
[`#adm5`](#adm5)
[`#affected`](#affected)
[`#beneficiary`](#beneficiary)
[`#capacity`](#capacity)
[`#cause`](#cause)
[`#channel`](#channel)
[`#contact`](#contact)
[`#country`](#country)
[`#crisis`](#crisis)
[`#currency`](#currency)
[`#date`](#date)
[`#description`](#description)
[`#event`](#event)
[`#frequency`](#frequency)
[`#geo`](#geo)
[`#group`](#group)
[`#impact`](#impact)
[`#indicator`](#indicator)
[`#inneed`](#inneed)
[`#item`](#item)
[`#loc`](#loc)
[`#meta`](#meta)
[`#modality`](#modality)
[`#need`](#need)
[`#operations`](#operations)
[`#org`](#org)
[`#output`](#output)
[`#population`](#population)
[`#reached`](#reached)
[`#region`](#region)
[`#respondee`](#respondee)
[`#sector`](#sector)
[`#service`](#service)
[`#severity`](#severity)
[`#status`](#status)
[`#subsector`](#subsector)
[`#targeted`](#targeted)
[`#value`](#value)


## (1) Places

### `#adm1`

Top-level subnational administrative area (e.g. a governorate in Syria). _Since version 1.0_

Attributes: [`+code`](ATTRIBUTES.md#code) [`+dest`](ATTRIBUTES.md#dest) [`+name`](ATTRIBUTES.md#name) [`+origin`](ATTRIBUTES.md#origin)

### `#adm2`

Second-level subnational administrative area (e.g. a subdivision in Bangladesh). _Since version 1.0_

Attributes: [`+code`](ATTRIBUTES.md#code) [`+dest`](ATTRIBUTES.md#dest) [`+name`](ATTRIBUTES.md#name) [`+origin`](ATTRIBUTES.md#origin)

### `#adm3`

Third-level subnational administrative area (e.g. a subdistrict in Afghanistan). _Since version 1.0_

Attributes: [`+code`](ATTRIBUTES.md#code) [`+dest`](ATTRIBUTES.md#dest) [`+name`](ATTRIBUTES.md#name) [`+origin`](ATTRIBUTES.md#origin)

### `#adm4`

Fourth-level subnational administrative area (e.g. a barangay in the Philippines). _Since version 1.0_

Attributes: [`+code`](ATTRIBUTES.md#code) [`+dest`](ATTRIBUTES.md#dest) [`+name`](ATTRIBUTES.md#name) [`+origin`](ATTRIBUTES.md#origin)

### `#adm5`

Fifth-level subnational administrative area (e.g. a ward of a city). _Since version 1.0_

Attributes: [`+code`](ATTRIBUTES.md#code) [`+dest`](ATTRIBUTES.md#dest) [`+name`](ATTRIBUTES.md#name) [`+origin`](ATTRIBUTES.md#origin)

### `#country`

Country (often left implied in a dataset). Also sometimes known as admin level 0. _Since version 1.0_

Attributes: [`+code`](ATTRIBUTES.md#code) [`+dest`](ATTRIBUTES.md#dest) [`+name`](ATTRIBUTES.md#name) [`+origin`](ATTRIBUTES.md#origin)

### `#geo`

Geodetic geometry information (points, lines, shapes). Use for latitude and longitude, as well as bounds information. _Since version 1.0_

Attributes: [`+bounds`](ATTRIBUTES.md#bounds) [`+coord`](ATTRIBUTES.md#coord) [`+elevation`](ATTRIBUTES.md#elevation) [`+lat`](ATTRIBUTES.md#lat) [`+lon`](ATTRIBUTES.md#lon)

### `#loc`

Any general location, such as a village, camp, or clinic. _Since version 1.0_

Attributes: [`+code`](ATTRIBUTES.md#code) [`+dest`](ATTRIBUTES.md#dest) [`+name`](ATTRIBUTES.md#name) [`+origin`](ATTRIBUTES.md#origin) [`+type`](ATTRIBUTES.md#type)

### `#region`

A broad, supra- or cross-national geographical region (e.g. Sahel, Horn of Africa, Central Asia, Caribbean). Not to be confused with "region" used as the name of a subnational area ([`#adm1`](#adm1)) in some countries. _Since version 1.0_

Attributes: [`+code`](ATTRIBUTES.md#code) [`+dest`](ATTRIBUTES.md#dest) [`+name`](ATTRIBUTES.md#name) [`+origin`](ATTRIBUTES.md#origin)

## (2) People and households

### `#affected`

Number of people or households affected by an emergency. Subset of [`#population`](#population); superset of [`#inneed`](#inneed). _Since version 1.0_

Every value must be a **number**.

Attributes: [`+abducted`](ATTRIBUTES.md#abducted) [`+adolescents`](ATTRIBUTES.md#adolescents) [`+adults`](ATTRIBUTES.md#adults) [`+children`](ATTRIBUTES.md#children) [`+displaced`](ATTRIBUTES.md#displaced) [`+elderly`](ATTRIBUTES.md#elderly) [`+f`](ATTRIBUTES.md#f) [`+hh`](ATTRIBUTES.md#hh) [`+i`](ATTRIBUTES.md#i) [`+idps`](ATTRIBUTES.md#idps) [`+incamp`](ATTRIBUTES.md#incamp) [`+ind`](ATTRIBUTES.md#ind) [`+infants`](ATTRIBUTES.md#infants) [`+infected`](ATTRIBUTES.md#infected) [`+injured`](ATTRIBUTES.md#injured) [`+killed`](ATTRIBUTES.md#killed) [`+m`](ATTRIBUTES.md#m) [`+noncamp`](ATTRIBUTES.md#noncamp) [`+refugees`](ATTRIBUTES.md#refugees)

### `#beneficiary`

General (non-numeric) information about a person or group meant to benefit from aid activities, e.g. "lactating women". _Since version 1.0_

Attributes: [`+code`](ATTRIBUTES.md#code) [`+name`](ATTRIBUTES.md#name) [`+type`](ATTRIBUTES.md#type)

### `#inneed`

Number of people or households in need of humanitarian assistance. Subset of [`#affected`](#affected); superset of [`#targeted`](#targeted). _Since version 1.0_

Every value must be a **number**.

Attributes: [`+abducted`](ATTRIBUTES.md#abducted) [`+adolescents`](ATTRIBUTES.md#adolescents) [`+adults`](ATTRIBUTES.md#adults) [`+children`](ATTRIBUTES.md#children) [`+displaced`](ATTRIBUTES.md#displaced) [`+elderly`](ATTRIBUTES.md#elderly) [`+f`](ATTRIBUTES.md#f) [`+hh`](ATTRIBUTES.md#hh) [`+i`](ATTRIBUTES.md#i) [`+idps`](ATTRIBUTES.md#idps) [`+incamp`](ATTRIBUTES.md#incamp) [`+ind`](ATTRIBUTES.md#ind) [`+infants`](ATTRIBUTES.md#infants) [`+infected`](ATTRIBUTES.md#infected) [`+injured`](ATTRIBUTES.md#injured) [`+m`](ATTRIBUTES.md#m) [`+noncamp`](ATTRIBUTES.md#noncamp) [`+refugees`](ATTRIBUTES.md#refugees)

### `#population`

General population number for an area or location, regardless of their specific humanitarian needs. _Since version 1.0_

Every value must be a **number**.

Attributes: [`+adolescents`](ATTRIBUTES.md#adolescents) [`+adults`](ATTRIBUTES.md#adults) [`+children`](ATTRIBUTES.md#children) [`+displaced`](ATTRIBUTES.md#displaced) [`+elderly`](ATTRIBUTES.md#elderly) [`+f`](ATTRIBUTES.md#f) [`+hh`](ATTRIBUTES.md#hh) [`+i`](ATTRIBUTES.md#i) [`+idps`](ATTRIBUTES.md#idps) [`+incamp`](ATTRIBUTES.md#incamp) [`+ind`](ATTRIBUTES.md#ind) [`+infants`](ATTRIBUTES.md#infants) [`+m`](ATTRIBUTES.md#m) [`+noncamp`](ATTRIBUTES.md#noncamp) [`+refugees`](ATTRIBUTES.md#refugees)

### `#reached`

Number of people or households reached with humanitarian assistance. Subset of [`#targeted`](#targeted). _Since version 1.0_

Every value must be a **number**.

Attributes: [`+abducted`](ATTRIBUTES.md#abducted) [`+adolescents`](ATTRIBUTES.md#adolescents) [`+adults`](ATTRIBUTES.md#adults) [`+children`](ATTRIBUTES.md#children) [`+displaced`](ATTRIBUTES.md#displaced) [`+elderly`](ATTRIBUTES.md#elderly) [`+f`](ATTRIBUTES.md#f) [`+hh`](ATTRIBUTES.md#hh) [`+i`](ATTRIBUTES.md#i) [`+idps`](ATTRIBUTES.md#idps) [`+incamp`](ATTRIBUTES.md#incamp) [`+ind`](ATTRIBUTES.md#ind) [`+infants`](ATTRIBUTES.md#infants) [`+infected`](ATTRIBUTES.md#infected) [`+injured`](ATTRIBUTES.md#injured) [`+m`](ATTRIBUTES.md#m) [`+noncamp`](ATTRIBUTES.md#noncamp) [`+refugees`](ATTRIBUTES.md#refugees)

### `#respondee`

Descriptive information, such as name, identifier, or traits, for a single respondee (person, household, etc.) in survey-style data. _Since version 1.1_

### `#targeted`

Number of people or households targeted for humanitarian assistance. Subset of [`#inneed`](#inneed); superset of [`#reached`](#reached). _Since version 1.0_

Every value must be a **number**.

Attributes: [`+abducted`](ATTRIBUTES.md#abducted) [`+adolescents`](ATTRIBUTES.md#adolescents) [`+adults`](ATTRIBUTES.md#adults) [`+children`](ATTRIBUTES.md#children) [`+displaced`](ATTRIBUTES.md#displaced) [`+elderly`](ATTRIBUTES.md#elderly) [`+f`](ATTRIBUTES.md#f) [`+hh`](ATTRIBUTES.md#hh) [`+i`](ATTRIBUTES.md#i) [`+idps`](ATTRIBUTES.md#idps) [`+incamp`](ATTRIBUTES.md#incamp) [`+ind`](ATTRIBUTES.md#ind) [`+infants`](ATTRIBUTES.md#infants) [`+infected`](ATTRIBUTES.md#infected) [`+injured`](ATTRIBUTES.md#injured) [`+m`](ATTRIBUTES.md#m) [`+noncamp`](ATTRIBUTES.md#noncamp) [`+refugees`](ATTRIBUTES.md#refugees)

## (3) Responses and other operations

### `#access`

Accessiblity and constraints on access to a market, distribution point, facility, etc. _Since version 1.1_

Attributes: [`+type`](ATTRIBUTES.md#type)

### `#activity`

A programme, project, or other activity. This hashtag applies to all levels; use the attributes +activity, +project, or +programme to distinguish different hierarchical levels. _Since version 1.0_

Attributes: [`+activity`](ATTRIBUTES.md#activity) [`+code`](ATTRIBUTES.md#code) [`+name`](ATTRIBUTES.md#name) [`+programme`](ATTRIBUTES.md#programme) [`+project`](ATTRIBUTES.md#project) [`+type`](ATTRIBUTES.md#type) [`+url`](ATTRIBUTES.md#url)

### `#capacity`

The response capacity of the entity being described (e.g. "25 beds"). _Since version 1.0_

Attributes: [`+num`](ATTRIBUTES.md#num) [`+type`](ATTRIBUTES.md#type)

### `#contact`

Contact information for the subject of a data record (e.g. an activity). _Since version 1.0_

Attributes: [`+email`](ATTRIBUTES.md#email) [`+name`](ATTRIBUTES.md#name) [`+phone`](ATTRIBUTES.md#phone) [`+type`](ATTRIBUTES.md#type) [`+url`](ATTRIBUTES.md#url)

### `#frequency`

The frequency with which something occurs. _Since version 1.1_

Attributes: [`+type`](ATTRIBUTES.md#type)

### `#indicator`

A general hashtag for an indicator being tracked. See also [`#output`](#output), [`#capacity`](#capacity), [`#need`](#need), [`#impact`](#impact), [`#severity`](#severity), [`#affected`](#affected), [`#inneed`](#inneed), [`#targeted`](#targeted), and [`#reached`](#reached) for more-specific indicator-related hashtags. _Since version 1.0_

Attributes: [`+code`](ATTRIBUTES.md#code) [`+name`](ATTRIBUTES.md#name) [`+num`](ATTRIBUTES.md#num) [`+text`](ATTRIBUTES.md#text) [`+type`](ATTRIBUTES.md#type)

### `#item`

Physical things provided, stored, shipped, available, used, etc. _Since version 1.1_

Attributes: [`+code`](ATTRIBUTES.md#code) [`+name`](ATTRIBUTES.md#name) [`+provided`](ATTRIBUTES.md#provided) [`+type`](ATTRIBUTES.md#type) [`+used`](ATTRIBUTES.md#used)

### `#need`

A(n) (unfulfilled) need for an affected person, household, group, or population. _Since version 1.1_

Attributes: [`+code`](ATTRIBUTES.md#code) [`+name`](ATTRIBUTES.md#name) [`+type`](ATTRIBUTES.md#type)

### `#operations`

Information that affects humanitarian operations, such as a restriction on movement or road closure. _Since version 1.0_

Attributes: [`+type`](ATTRIBUTES.md#type)

### `#org`

An organisation contributing to a humanitarian emergency response, e.g. a local government, community-based organisation, NGO, agency, donor, or law-enforcement or military unit. Use [`#group`](#group) for organisations that are not part of the emergency response (e.g. a paramilitary group). _Since version 1.0_

Attributes: [`+code`](ATTRIBUTES.md#code) [`+funder`](ATTRIBUTES.md#funder) [`+impl`](ATTRIBUTES.md#impl) [`+name`](ATTRIBUTES.md#name) [`+prog`](ATTRIBUTES.md#prog) [`+type`](ATTRIBUTES.md#type) [`+url`](ATTRIBUTES.md#url)

### `#output`

An output indicator (e.g. "number of water-purification kits distributed"). A more-specific alternative to [`#indicator`](#indicator), especially for 3W-style activity reports. _Since version 1.0_

Attributes: [`+code`](ATTRIBUTES.md#code) [`+name`](ATTRIBUTES.md#name) [`+num`](ATTRIBUTES.md#num) [`+type`](ATTRIBUTES.md#type)

### `#sector`

A humanitarian cluster or sector. _Since version 1.0_

Attributes: [`+cluster`](ATTRIBUTES.md#cluster) [`+code`](ATTRIBUTES.md#code) [`+name`](ATTRIBUTES.md#name) [`+type`](ATTRIBUTES.md#type)

### `#service`

A service used or needed by an affected person, household, group, or population. _Since version 1.1_

Attributes: [`+code`](ATTRIBUTES.md#code) [`+name`](ATTRIBUTES.md#name) [`+provided`](ATTRIBUTES.md#provided) [`+type`](ATTRIBUTES.md#type) [`+url`](ATTRIBUTES.md#url) [`+used`](ATTRIBUTES.md#used)

### `#subsector`

A humanitarian subsector. _Since version 1.0_

Attributes: [`+code`](ATTRIBUTES.md#code) [`+name`](ATTRIBUTES.md#name) [`+type`](ATTRIBUTES.md#type)

## (4) Cash and finance

### `#channel`

The detailed method of delivering aid (e.g. smartcard vs mobile transfer). More specific than [`#modality`](#modality). _Since version 1.1_

Attributes: [`+code`](ATTRIBUTES.md#code) [`+name`](ATTRIBUTES.md#name)

### `#currency`

Name or ISO 4217 currency code for all financial [`#value`](#value) cells in the row (e.g. "EUR"). Typically used together with [`#value`](#value) in financial or cash data. _Since version 1.1_

Attributes: [`+code`](ATTRIBUTES.md#code)

### `#modality`

The means by which an aid activity is accomplished. For cash transfers, values might include "cash", "vouchers", "in-kind", etc. May also be used for other types of modalities in other contexts. _Since version 1.1_

Attributes: [`+code`](ATTRIBUTES.md#code) [`+name`](ATTRIBUTES.md#name)

### `#value`

A monetary value, such as the price of goods in a market, a project budget, or the amount of cash transferred to beneficiaries. May be used together with [`#currency`](#currency) in financial or cash data. _Since version 1.1_

Every value must be a **number**.

## (5) Crises, incidents, and events

### `#cause`

The cause of an event, crisis, etc. _Since version 1.0_

Attributes: [`+code`](ATTRIBUTES.md#code) [`+name`](ATTRIBUTES.md#name) [`+type`](ATTRIBUTES.md#type)

### `#crisis`

A humanitarian emergency. _Since version 1.0_

Attributes: [`+code`](ATTRIBUTES.md#code) [`+name`](ATTRIBUTES.md#name) [`+type`](ATTRIBUTES.md#type)

### `#event`

An individual event or incident within a crisis/emergency, such as a (localised) flood, bridge collapse, or conflict. _Since version 1.0_

Attributes: [`+code`](ATTRIBUTES.md#code) [`+name`](ATTRIBUTES.md#name) [`+type`](ATTRIBUTES.md#type)

### `#group`

A non-humanitarian group (of any type) related to humanitarian crisis (e.g., a paramilitary group) Use [`#org`](#org) instead for a humanitarian organisation such as an NGO, contributing to the humanitarian response. _Since version 1.0_

Attributes: [`+code`](ATTRIBUTES.md#code) [`+name`](ATTRIBUTES.md#name) [`+type`](ATTRIBUTES.md#type)

### `#impact`

The impact of a crisis on a group or other entity. _Since version 1.0_

Attributes: [`+code`](ATTRIBUTES.md#code) [`+name`](ATTRIBUTES.md#name) [`+type`](ATTRIBUTES.md#type)

### `#severity`

Severity of the crisis or event. _Since version 1.0_

Attributes: [`+code`](ATTRIBUTES.md#code) [`+name`](ATTRIBUTES.md#name) [`+type`](ATTRIBUTES.md#type)

## (6) Metadata

### `#date`

Date related to the data in the record applies. Preferred format is ISO 8610 (e.g. "2015-06-01", "2015-Q1", etc.) _Since version 1.0_

Every value must be a **date**.

Attributes: [`+approved`](ATTRIBUTES.md#approved) [`+canceled`](ATTRIBUTES.md#canceled) [`+converted`](ATTRIBUTES.md#converted) [`+end`](ATTRIBUTES.md#end) [`+occurred`](ATTRIBUTES.md#occurred) [`+reported`](ATTRIBUTES.md#reported) [`+start`](ATTRIBUTES.md#start)

### `#description`

Long description for a data record. _Since version 1.0_

Attributes: [`+type`](ATTRIBUTES.md#type)

### `#meta`

Metadata about a row. _Since version 1.0_

Attributes: [`+id`](ATTRIBUTES.md#id) [`+source`](ATTRIBUTES.md#source) [`+url`](ATTRIBUTES.md#url)

### `#status`

Project/activity status description (such as "planned", "active", "canceled", or "complete"). _Since version 1.0_

Attributes: [`+code`](ATTRIBUTES.md#code) [`+name`](ATTRIBUTES.md#name)

