******************
* SPAM 2017 V1r1 *
******************
* Junly-10-2020  *
******************
Difference to previous version SPAM 2017 V1r0:
One more group was added at the end: "banpl" = banana + plantain
All zip files have data for all crops and groups
Physical areas are not included
Rainfed high, low and subsistence technologies are not included
Aggregated (total, food, non-food) value of production is not included
New zip file with aggregations to admin level 1
NONE of the files has the text 'global' in their names! It is just 'SSA'
***********************************************************************

RESULTS for SPAM 2017 V1r1 - only SSA

Pixel values for 5 variables and 3 technologies, with individual crops and crop groups in each record, csv format
Pixel values for 5 variables and 3 technologies, with individual crops and crop groups in each record, dbf format
Pixel values for 5 variables, 3 technologies, 42 crops and 9 crop groups, tif format
Admin_level 1 values for 5 variables and 3 technologies, with individual crops and crop groups in each record, dbf and csv format

***********************************************************************
----------------
FOLDER SPAM2017
----------------
- spam2017V1r1_SSA_With_Groups.csv.zip
   SPAM results, global pixels, files in csv format for variables H, P, V, YQ, YV and 3 technologies: A, I and R, filename type I
- spam2017V1r1_SSA_With_Groups.dbf.zip
   SPAM results, global pixels, files in dbf format for variables  H, P, V, YQ, YV and 3 technologies: A, I and R, filename type I
- Spam2017V1r1_SSA_level1.zip
   SPAM results, aggregated to admin level 1, files in dbf and csv formats for variables H, P, V, YQ, YV and 3 technologies: A, I and R, filename type II

-----------------------
FOLDER SPAM2017/GEOTIFF
-----------------------
- spam2017V1r1_SSA_harv_area.geotiff.zip
   SPAM harvested area, global pixels, files in tif format for 3 technologies x 42 crops and 9 groups, filename type III 
- spam2017V1r1_SSA_prod.geotiff.zip
   SPAM production, global pixels, files in tif format for 3 technologies x 42 crops and 9 groups, filename type III 
- spam2017V1r1_SSA_val_prod.geotiff.zip
   SPAM value of production, global pixels, files in tif format for 3 technologies x 42 crops and 9 groups, filename type III 
- spam2017V1r1_SSA_yield_quant.geotiff.zip
   SPAM yield of quantity, global pixels, files in tif format for 3 technologies x 42 crops and 9 groups, filename type III 
- spam2017V1r1_global_SSA_yield_value.geotiff.zip
   SPAM yield of value, global pixels, files in tif format for 6 technologies x 42 crops and 8 groups, filename type III 
  	

File name type I (pixelized values)
***********************************
All files have standard names, which allow direct identification of variable and technology:
spam2017V1r1_SSA_gr_v_t.fff
where
v   = variable 
t   = technology
fff = file format

v: Variables
-----------------
_H_		harvested area
_P_		production
_V_		value of production
_YQ_		yield quantity (production per ha) 
_YV_		yield value (I$ per ha)

t: Technologies
---------------
*_TA	all technologies together, ie complete crop or crop group
*_TI	irrigated portion of crop or crop group
*_TR	rainfed portion of crop or crop group (= TA - TI)

fff: File formats
-----------------
*.dbf	FoxPlus, directly readable by ArcGis
*.csv	comma separated values

Structure of file name type I (pixelized values)
************************************************
each record has

9 fields to identify a pixel:
   ISO3, prod_level (=fips2), alloc_key (SPAM pixel id), cell5m (cell5m id), x (x-coordinate - longitude of centroid), y (y-coordinate - latitude of centroid), rec_type (see variables above), tech_type (see technologies above), unit (same in each zip file, for all values)

42 fields for 42 crops with notation:  crop_T, where T = A, I, or R (see crops below)

9 fields for 9 crop groups (see below) with same notation as crops: group_T, where T = A, I, or R

7 fields for annotations: 
   creation data of data, year_data (years of statistics used), source (source for scaling, always FAO avg(2004-06), name_cntr, name_adm1, name_adm2 (all derived from prod_level field)



File name type II (admin level 1 values)
****************************************
All files have standard names, which allow direct identification of variable and technology:
Spam2017V1r1_SSA_level1_v_t.fff
where
level1 = denotes level of aggregation, in this case admin level 1
v      = variable 
t      = technology
fff    = file format

v: Variables
-----------------
_H_		harvested area
_P_		production
_V_		value of production
_YQ_		yield quantity (production per ha) 
_YV_		yield value (I$ per ha)

t: Technologies
---------------
*_TA	all technologies together, ie complete crop or crop group
*_TI	irrigated portion of crop or crop group
*_TR	rainfed portion of crop or crop group (= TA - TI)

fff: File formats
-----------------
*.dbf	dbf format, readable by many applications
*.csv	comma separated values

Structure of file name type II (admin level 1 values)
*****************************************************
similar to pixel files type I, but all identification is moved to the front

each record has

8 fields to identify an admin level1 unit:
   ISO3, prod_level (=fips1), name_cntr, name_adm1, name_adm2 (empty here) (all derived from prod_level field), rec_type (see variables above), tech_type (see technologies above), unit (same in each zip file, for all values)

42 fields for 42 crops (see crop list below)

9 fields for 9 crop groups (see list below)


File name type III (tif files)
******************************
All files have standard names, which allow direct identification of crop, variable and technology:
spam2017V1r1_SSA_gr_v_crop_t.tif
where
gr   = group, part of the name, to indicate that the complete SPAM records have individual crops and crop groups
v    = variable
crop = short crop or group name (see below) 
t    = technology

v: Variables
------------
_H_		harvested area
_P_		production
_V_		value of production
_YQ_		yield quantity (kg/ha)
_YV_		yield value (I$/ha)

t: Technologies
---------------
_A	all technologies together, ie complete crop or crop group
_I	irrigated portion of crop or crop group
_R	rainfed portion of crop or crop group (= TA - TI)

Structure of file name type III (tif files)
*******************************************
Standard geotiff file format


***********
Crops list:
***********
crop #	full name	field and partial file name
1	wheat			whea
2	rice			rice
3	maize			maiz
4	barley			barl
5	pearl millet		pmil
6	small millet		smil
7	sorghum			sorg
8	other cereals		ocer
9	potato			pota
10	sweet potato		swpo
11	yams			yams
12	cassava			cass
13	other roots		orts
14	bean			bean
15	chickpea		chic
16	cowpea			cowp
17	pigeonpea		pige
18	lentil			lent
19	other pulses		opul
20	soybean			soyb
21	groundnut		grou
22	coconut			cnut
23	oilpalm			oilp
24	sunflower		sunf
25	rapeseed		rape
26	sesameseed		sesa
27	other oil crops		ooil
28	sugarcane		sugc
29	sugarbeet		sugb
30	cotton			cott
31	other fibre crops 	ofib
32	arabica coffee		acof	
33	robusta coffee		rcof	
34	cocoa			coco	
35	tea			teas	
36	tobacco			toba	
37	banana			bana	
38	plantain		plnt	
39	tropical fruit		trof	
40	temperate fruit		temf	
41	vegetables		vege	
42	rest of crops		rest	

**************************************
Crop group names and their membership:
**************************************
group #	full name   field and partial file name    include crops n to m
1	total			total			1	42
2	cereal			cere			1	8
3	roots			root			9	13
4	pulses			puls			14	19
5	oilcrops		oilc			20	27
6	millet			mill			5	6
7	coffee			coff			32	33
8	fruit			fruit			39	40
9	banana+plantains	banpl			37	38