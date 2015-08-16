from flask import Flask, render_template, request, jsonify, make_response, g
import numpy as np
import random
import StringIO
import sqlite3
from contextlib import closing
import pandas as pd
from sklearn.metrics.pairwise import euclidean_distances
import sys
# from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas
# from matplotlib.figure import Figure

# configuration
DATABASE = 'flaskr.db'
DEBUG = True
SECRET_KEY = 'development key'
USERNAME = 'admin'
PASSWORD = 'default'

# create the application object
app = Flask(__name__)
app.config.from_object(__name__)


def connect_db():
    return sqlite3.connect(app.config['DATABASE'])

def init_db():
    with closing(connect_db()) as db:
        with app.open_resource('schema.sql', mode='r') as f:
            db.cursor().executescript(f.read())
        db.commit()

# def zip_distance(given_zip):
#     global df
#     target_zips = df['zip']
#     df_targets = df[df.zip.isin(target_zips)]
#     given_zip_data = df[df.zip == given_zip]
#     zip_dist = euclidean_distances(df_targets.values, given_zip_data.values)
#     dist_list = zip_dist.reshape(df_targets.shape[0],)
#     zip_list = df_targets.ix[:,0].astype(int)
#     zip_dist_dict = dict(zip(zip_list, dist_list.T))
#     return zip_dist_dict


def zip_distance(given_zip):
    global df
    zip_dist_dict = {}

    if given_zip != '':
        target_zips = df['zip']
        df_targets = df[df.zip.isin(target_zips)]
        print given_zip
        given_zip_data = df[df.zip == int(given_zip)]

        if not given_zip_data.empty and not df_targets.empty:
            zip_dist = euclidean_distances(df_targets.values, given_zip_data.values)
            dist_list = zip_dist.reshape(df_targets.shape[0],)
            zip_list = df_targets.ix[:,0].astype(int)
            zip_dist_dict = dict(zip(zip_list, dist_list.T))

    return zip_dist_dict

g_zip_feature_scores = []

def ReadPersScores(a_zipPersScoresFilepath):
    global g_zip_feature_scores
    score_file = open(a_zipPersScoresFilepath, "r")
    header_line = score_file.readline().strip()
    header_fields = header_line.split(",")
    header_fields = [ ff.strip() for ff in header_fields ]
    feature_normalized_score_indices = {}
    ii = 0
    for ff in header_fields:
        if ff.startswith("N_"):
            feature_normalized_score_indices[ff[2:]] = ii
        ii += 1
    for one_line in score_file:
        score_fields = one_line.strip().split(",")
        score_fields = [ ff.strip() for ff in score_fields ]
        the_zip = score_fields[0]
        zip_score_map = {}
        for kk in feature_normalized_score_indices.keys():
            feature_index = feature_normalized_score_indices[kk]
            if score_fields[feature_index] == 'NA':
                zip_score_map[kk] = 'NA'
            else:
                zip_score_map[kk] = float(score_fields[feature_index])
        g_zip_feature_scores.append((the_zip, zip_score_map))
    score_file.close()


def CalcPersScore(a_featureWeights):
    zip_scores = {}
    for one_zip in g_zip_feature_scores:
        norm_scores = one_zip[1]
        score_sum   = 0
        score_count = 0
        for ff in a_featureWeights.keys():
            # print "Feature-name: ", ff
            if ff not in norm_scores:
                print "Warning: feature name '%s' not in data file." % ff
                continue
            if norm_scores[ff] != 'NA':
                feature_weight = float(a_featureWeights[ff])
                score_sum   += (feature_weight / 100.0) * norm_scores[ff]
                score_count += 1
        zip_scores[one_zip[0]] = score_sum / score_count if score_count > 0 else 0
    return zip_scores

def normalized_zips(filtered_zipcodes):
    if all(x is None for x in filtered_zipcodes.values()) is False:
        min_value = min(filtered_zipcodes.values())
        max_value = max(filtered_zipcodes.values())
        distance = max_value - min_value
        normalized_scores = {}
        if min_value == max_value:
          normalized_scores = {zipcode: 100 for zipcode in filtered_zipcodes.keys()}
        else:
          normalized_scores = {zipcode: int((filtered_zipcodes[zipcode] - min_value)*100/distance) for zipcode in filtered_zipcodes.keys()}
        return normalized_scores

@app.before_request
def before_request():
    g.db = connect_db()

@app.teardown_request
def teardown_request(exception):
    db = getattr(g, 'db', None)
    if db is not None:
        db.close()

@app.route('/about.html')
def about():
  return render_template('about.html')

# use decorators to link the function to a url
@app.route('/')
@app.route('/index.html')
def home():
    if request.args == {}:
      return render_template('webapp.html', filters={}, rows=[])
    else:  
      filters = request.args
      rating_min = int(filters.get("SchoolRatingSlider"))
      price_level = filters.get("PriceSelect")
      min_price, max_price = price_level.split('-')
      min_price = int(min_price)
      max_price = int(max_price)
      available_house_types  = ["median_sale_price", "median_condo", "median_2_bedroom", "median_3_bedroom", "median_4_bedroom"]
      house_type = "median_sale_price"
      if filters.get("HouseTypeSelect") in available_house_types:
          house_type = filters.get("HouseTypeSelect")
      input_zipcode = filters.get("ZipInput")
      parameter_input = {'crime_index':int(filters.get("crime_index")), 'restaurants':int(filters.get("restaurants")), 'poverty_rate':int(filters.get("poverty_rate")), 'avg_temperature':int(filters.get("avg_temperature")), 'earthquake_index':int(filters.get("earthquake_index"))}
      personal_scores = normalized_zips(CalcPersScore(parameter_input))
      if filters.get("SchoolRadio") == None:
        # zips = "select zipcode from entries where school_ratings >= %d and %s between %d and %d group by 1" % (rating_min, house_type, min_price, max_price)
        filtered_zips = g.db.execute("select zipcode from entries where school_ratings >= ? and %s between ? and ? group by 1" % (house_type), [rating_min, min_price, max_price]).fetchall()
        filtered_zips = [int(tuplezip[0]) for tuplezip in filtered_zips]
        filtered_pers_zips = {zipcode: personal_scores[str(zipcode)] for zipcode in filtered_zips}
        # filtered_pers_zips = normalized_zips(filtered_pers_zips)
        similarity_scores = normalized_zips(zip_distance(input_zipcode))
        # query = "select zipcode, %s, avg(school_ratings), cast(round(score) as integer), cast(round(app_score) as integer) from entries where school_ratings >= %d and %s between %d and %d group by 1,2,4" % (house_type, rating_min, house_type, min_price, max_price)
        rows = g.db.execute("select zipcode, %s, avg(school_ratings), cast(round(score) as integer), cast(round(app_score) as integer) from entries where school_ratings >= ? and %s between ? and ? group by 1,2,4" % (house_type, house_type), [rating_min, min_price, max_price]).fetchall()
        # qual_scores = {int(row[0]): int(row[3]) for row in rows}
        # qual_scores = normalized_zips(qual_scores)
        # app_scores = {int(row[0]): int(row[4]) for row in rows}
        # app_scores = normalized_zips(app_scores)
        return render_template('webapp.html', filters=filters, rows=rows, filtered_pers_zips=filtered_pers_zips, similarity_scores=similarity_scores)
      else:
        # school_level = ('\'%' + filters.get("SchoolRadio") + '%\'')
        school_level = filters.get("SchoolRadio")
        # zips = "select zipcode from entries where grade_level like %s and school_ratings >= %d and %s between %d and %d group by 1" % (school_level, rating_min, house_type, min_price, max_price)
        filtered_zips = g.db.execute("select zipcode from entries where grade_level like ? and school_ratings >= ? and %s between ? and ? group by 1" % (house_type), ['%' + school_level + '%', rating_min, min_price, max_price]).fetchall()
        filtered_zips = [int(tuplezip[0]) for tuplezip in filtered_zips]
        filtered_pers_zips = {zipcode: personal_scores[str(zipcode)] for zipcode in filtered_zips}
        # filtered_pers_zips = normalized_zips(filtered_pers_zips)
        similarity_scores = normalized_zips(zip_distance(input_zipcode))
        # query = "select zipcode, %s, avg(school_ratings), cast(round(score) as integer), cast(round(app_score) as integer) from entries where grade_level like %s and school_ratings >= %d and %s between %d and %d group by 1,2,4" % (house_type, school_level, rating_min, house_type, min_price, max_price)
        rows = g.db.execute("select zipcode, %s, avg(school_ratings), cast(round(score) as integer), cast(round(app_score) as integer) from entries where grade_level like ? and school_ratings >= ? and %s between ? and ? group by 1,2,4" % (house_type, house_type), ['%' + school_level + '%', rating_min, min_price, max_price]).fetchall()
        # qual_scores = {int(row[0]): int(row[3]) for row in rows}
        # qual_scores = normalized_zips(qual_scores)
        # app_scores = {int(row[0]): int(row[4]) for row in rows}
        # app_scores = normalized_zips(app_scores)
        return render_template('webapp.html', filters=filters, rows=rows, filtered_pers_zips=filtered_pers_zips, similarity_scores=similarity_scores)

if __name__ == '__main__':
    ReadPersScores('pers_score_dataset.csv')
    fileName = "merged_fat.csv"
    df = pd.read_csv(fileName)
    app.run(debug=True, host='0.0.0.0')