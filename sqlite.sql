drop table entries;
create table entries (
  id integer primary key ,
  zipcode integer not null,
  gsid integer,
  school_name text,
  grade_range text,
  school_type text,
  grade_level text,
  alternative boolean,
  school_ratings integer,
  median_list_price numeric,
  median_sale_price numeric,
  median_single_family numeric,
  median_2_bedroom numeric,
  median_3_bedroom numeric,
  median_4_bedroom numeric,
  median_condo numeric,
  median_list_price_per_sqft numeric,
  for_sale_link text,
  score numeric,
  app_score numeric);

.separator "\t"
.import data.tsv entries