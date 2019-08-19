######################################################
# Flask App:
######################################################

#########################################
# DEPENDENCIES:
#########################################
from flask import Flask, render_template, redirect
from flask_pymongo import PyMongo

import scrape_mars


#########################################
# initialize the app:
#########################################
app = Flask(__name__)


#########################################
# connect to the Mongo DB:
#########################################
app.config['MONGO_URI'] = 'mongodb://localhost:27017/mars_db'
mongo = PyMongo(app)


#########################################
# Home Page: To display the mars data that
#            was scraped when pushing the button
#########################################
# Home Route: 
@app.route('/')
def index():
    mars_table = mongo.db.mars_table.find_one()

    return render_template('index.html', mars_table = mars_table)


# WebScraping Script Activation:
@app.route('/scrape')
def scrape_fqn():

    # to initialize the collection:
    mars_table = mongo.db.mars_table

    # to run the scrape function from scrape_mars.py:
    mars_data = scrape_mars.scrape()

    # to update the collection with scrape data:
    mars_table.update({}, mars_data, upsert=True)

    
    # to return to the homepage route:
    return redirect('/', code=302)



# to close out the app:
if __name__ == "__main__":
    app.run(debug=True)


