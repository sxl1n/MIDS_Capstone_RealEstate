#!/usr/bin/python

import sys

# Zillow median home price dataset has these fields:
zillow_data_set_fields = """
"RegionName","City","State","Metro","CountyName","1996-04","1996-05","1996-06","1996-07","1996-08","1996-09","1996-10","1996-11","1996-12","1997-01","1997-02","1997-03","1997-04","1997-05","1997-06","1997-07","1997-08","1997-09","1997-10","1997-11","1997-12","1998-01","1998-02","1998-03","1998-04","1998-05","1998-06","1998-07","1998-08","1998-09","1998-10","1998-11","1998-12","1999-01","1999-02","1999-03","1999-04","1999-05","1999-06","1999-07","1999-08","1999-09","1999-10","1999-11","1999-12","2000-01","2000-02","2000-03","2000-04","2000-05","2000-06","2000-07","2000-08","2000-09","2000-10","2000-11","2000-12","2001-01","2001-02","2001-03","2001-04","2001-05","2001-06","2001-07","2001-08","2001-09","2001-10","2001-11","2001-12","2002-01","2002-02","2002-03","2002-04","2002-05","2002-06","2002-07","2002-08","2002-09","2002-10","2002-11","2002-12","2003-01","2003-02","2003-03","2003-04","2003-05","2003-06","2003-07","2003-08","2003-09","2003-10","2003-11","2003-12","2004-01","2004-02","2004-03","2004-04","2004-05","2004-06","2004-07","2004-08","2004-09","2004-10","2004-11","2004-12","2005-01","2005-02","2005-03","2005-04","2005-05","2005-06","2005-07","2005-08","2005-09","2005-10","2005-11","2005-12","2006-01","2006-02","2006-03","2006-04","2006-05","2006-06","2006-07","2006-08","2006-09","2006-10","2006-11","2006-12","2007-01","2007-02","2007-03","2007-04","2007-05","2007-06","2007-07","2007-08","2007-09","2007-10","2007-11","2007-12","2008-01","2008-02","2008-03","2008-04","2008-05","2008-06","2008-07","2008-08","2008-09","2008-10","2008-11","2008-12","2009-01","2009-02","2009-03","2009-04","2009-05","2009-06","2009-07","2009-08","2009-09","2009-10","2009-11","2009-12","2010-01","2010-02","2010-03","2010-04","2010-05","2010-06","2010-07","2010-08","2010-09","2010-10","2010-11","2010-12","2011-01","2011-02","2011-03","2011-04","2011-05","2011-06","2011-07","2011-08","2011-09","2011-10","2011-11","2011-12","2012-01","2012-02","2012-03","2012-04","2012-05","2012-06","2012-07","2012-08","2012-09","2012-10","2012-11","2012-12","2013-01","2013-02","2013-03","2013-04","2013-05","2013-06","2013-07","2013-08","2013-09","2013-10","2013-11","2013-12","2014-01","2014-02","2014-03","2014-04","2014-05","2014-06","2014-07","2014-08","2014-09","2014-10","2014-11","2014-12","2015-01","2015-02","2015-03","2015-04","2015-05"
"""

def main(a_zipFilepath, a_priceFilepath):
    zip_list = []

    zip_file = open(a_zipFilepath, "r")
    for one_line in zip_file:
        zip_list.append(one_line.strip().split(',')[0])
    zip_file.close()

    zip_set = set(zip_list)

    header = "#ZIP, City, County, State,"
    price_years = [ x for x in xrange(1996,2016) ]

    for yy in price_years:
        header += ' Year_' + str(yy) + ','

    zip_avg_price = {}

    price_file = open(a_priceFilepath, "r")

    header_fields = price_file.readline().replace('"','').split(",")

    for one_line in price_file:
        row_fields = one_line.strip().replace('"','').split(",")
        row_zip = row_fields[0]
        if not row_zip in zip_set: continue # Skip if this is not in SF bay area!

        if row_zip not in zip_avg_price:
            zip_avg_price[row_zip] = {}

        zip_avg_price[row_zip]['city']   = row_fields[1]
        zip_avg_price[row_zip]['county'] = row_fields[4]
        zip_avg_price[row_zip]['state']  = row_fields[2]

        for ii in xrange(5, len(row_fields)):
            price_year = header_fields[ii][0:4]

            if price_year not in zip_avg_price[row_zip]:
                zip_avg_price[row_zip][price_year] = []

            if row_fields[ii]:  # If price is not empty store it in list.
                zip_avg_price[row_zip][price_year].append(row_fields[ii])

    price_file.close()


    # Now print out per year average median home price for each zip
    print header

    for one_zip in zip_avg_price.keys():
        year_keys = zip_avg_price[one_zip].keys()
        year_keys.sort()

        print "%s, %s, %s, %s," % (one_zip, zip_avg_price[one_zip]['city'], zip_avg_price[one_zip]['county'], zip_avg_price[one_zip]['state']),

        for yy in year_keys:
            if not yy.isdigit(): continue # Ignore keys like: city, county, state!

            sum_price = 0
            sum_count = 0

            # print "ZIP:", one_zip, ", Year:", yy, "Price array:", zip_avg_price[one_zip][yy]

            for pp in zip_avg_price[one_zip][yy]:
                sum_price += float(pp)
                sum_count += 1

            if sum_count != 0:
                print "%0.2f," % (sum_price / sum_count),
            else:
                print "NA,",

        print ""


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print >> sys.stderr, sys.argv[0], ": Usage:", sys.argv[0], "<zip-info-csv> <zip-median-price-csv>"
        sys.exit(1)

    main(sys.argv[1], sys.argv[2])
    sys.exit(0)

