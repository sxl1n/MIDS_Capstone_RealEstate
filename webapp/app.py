from flask import Flask, render_template, request, jsonify, make_response, g
import numpy as np
import random
import StringIO
import sqlite3
from contextlib import closing
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

@app.before_request
def before_request():
    g.db = connect_db()

@app.teardown_request
def teardown_request(exception):
    db = getattr(g, 'db', None)
    if db is not None:
        db.close()


# use decorators to link the function to a url
@app.route('/')
@app.route('/index.html')
def home():
    if request.args == {}:
      return render_template('webapp.html', filters={}, rows=[])
    else:  
      filters = request.args
      school_level = ('\'%' + filters.get("SchoolRadio") + '%\'')
      rating_min = int(filters.get("SchoolRatingSlider"))
      price_level = filters.get("PriceSelect")
      min_price, max_price = price_level.split('-')
      min_price = int(min_price)
      max_price = int(max_price)
      house_type = filters.get("HouseTypeSelect")
      query = "select zipcode, %s, avg(school_ratings), score from entries where grade_level like %s and school_ratings >= %d and school_ratings <> 'None' and %s between %d and %d group by 1,2,4" % (house_type, school_level, rating_min, house_type, min_price, max_price)
      rows = g.db.execute(query).fetchall()
      return render_template('webapp.html', filters=filters, rows=rows)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')