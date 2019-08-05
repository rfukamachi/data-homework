#################################################
# Dependencies
#################################################
import datetime as dt
import numpy as np

import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func

from flask import Flask, jsonify


#################################################
# Database Setup
#################################################
engine = create_engine("sqlite:///Resources/hawaii.sqlite")

#reflect database into a new model:
Base = automap_base()
#reflect the tables:
Base.prepare(engine, reflect=True)

#save references to the tables:
Measurement = Base.classes.measurement
Station = Base.classes.station




#################################################
# Flask Setup
#################################################
app = Flask(__name__)



#################################################
# 3. ID Flask Routes:
#################################################
@app.route("/")
def home():
    # for debugging:
    print("Server received request for 'Home' page...")
    # for webpage:
    return (
        f"Welcome to the Climate App<br/>"
        f"<br/>"
        f"<br/>"

        f"Here are the available routes:<br/>"
        f"<br/>"
        
        f"To get the precipitation data in JSON format:<br/>"
        f"/api/v1.0/precipitation<br/>"
        f"<br/>"
        
        f"To get the station data in JSON format:<br/>"
        f"/api/v1.0/stations<br/>"
        f"<br/>"

        f"To get the temperature observation data in JSON format:<br/>"
        f"/api/v1.0/tobs<br/>"
        f"<br/>"
        f"<br/>"


        f"For the following 2 routes, use the date format 'yyyy-mm-dd' for the square bracket parameters<br/>"
        f"Note: Do not include the square brackets in the routes<br/>"
        f"Example: /api/v1.0/temp_stats/2016-01-31"
        f"<br/>"
        f"<br/>"
        f"<br/>"

        f"To get the JSON list of minimum temperature, the average temperature, and the max temperature for dates greater than and equal to the start date:<br/>"
        f"/api/v1.0/temp_stats/[start_date]<br/>"
        f"<br/>"
        
        f"To get the JSON list of minimum temperature, the average temperature, and the max temperature for dates between the start and end date inclusive:<br/>"
        f"/api/v1.0/temp_stats/[start_date]/[end_date]<br/>"
        f"<br/>"
    )
    


#################################################
# * `/api/v1.0/precipitation`
#   * Convert the query results to a Dictionary using `date` as the key and `prcp` as the value.
#   * Return the JSON representation of your dictionary.
#################################################
@app.route("/api/v1.0/precipitation")
def precipitation():
    #create the session (link) from Python to the DB:
    session = Session(engine)  

    # Query all precipitations:
    results = session.query(Measurement.date, Measurement.prcp) \
              .order_by(Measurement.date).all()

    # Create a dictionary:
    all_prcps = []
    for date, prcp in results:
        prcp_dict = {}
        prcp_dict["date"] = date
        prcp_dict["prcp"] = prcp
        all_prcps.append(prcp_dict)
    
    session.close()

    return jsonify(all_prcps)




#################################################
# * `/api/v1.0/stations`
#   * Return a JSON list of stations from the dataset.
#################################################
@app.route("/api/v1.0/stations")
def stations():
    #create the session (link) from Python to the DB:
    session = Session(engine)
    
    # Query all stations:
    results = session.query(Station.station).order_by(Station.station).all()

    # Create a list:
    all_stations = []
    for station in results:
        all_stations.append(station)

    session.close()

    return jsonify(all_stations)



#################################################
# * `/api/v1.0/tobs`
#   * query for the dates and temperature observations from a year from the last data point.
#   * Return a JSON list of Temperature Observations (tobs) for the previous year.
#################################################
@app.route("/api/v1.0/tobs")
def tobs():
    #create the session (link) from Python to the DB:
    session = Session(engine)

    # Query:
    results = session.query(Measurement.date, Measurement.tobs) \
              .filter(Measurement.date >= '2016-08-24') \
              .filter(Measurement.date <= '2017-08-23') \
              .order_by(Measurement.date)

    # Create a dictionary:
    all_tobs = []

    for date, tobs in results:
        tobs_dict = {}
        tobs_dict["date"] = date
        tobs_dict["tobs"] = tobs
        all_tobs.append(tobs_dict)
    
    session.close()

    return jsonify(all_tobs)



################################################## 
# * `/api/v1.0/<start>` and `/api/v1.0/<start>/<end>`
#   * Return a JSON list of the minimum temperature, the average temperature, and the max temperature for a given start or start-end range.
#   * When given the start only, calculate `TMIN`, `TAVG`, and `TMAX` for all dates greater than and equal to the start date.
#   * When given the start and the end date, calculate the `TMIN`, `TAVG`, and `TMAX` for dates between the start and end date inclusive.
#################################################
@app.route("/api/v1.0/temp_stats/<start>")
@app.route("/api/v1.0/temp_stats/<start>/<end>")
def temp_stats(start=None, end=None):

    #create the session (link) from Python to the DB:
    session = Session(engine)



    # if the start date is only provided:
    #################################################
    if not end:
        # Query Prep:
        query_date = dt.datetime.strptime(start, "%Y-%m-%d")

        temp_sel = [func.min(Measurement.tobs),
                    func.avg(Measurement.tobs),
                    func.max(Measurement.tobs)]

        # Query:
        results = session.query(*temp_sel) \
                    .filter(Measurement.date >= query_date) \
                    .order_by(Measurement.date)  

       
        # Create a dictionary:
        all_stats = []
        for tmin, tavg, tmax in results:
            stat_dict = {}
            stat_dict["TMIN"] = tmin
            stat_dict["TAVG"] = tavg
            stat_dict["TMAX"] = tmax
            all_stats.append(stat_dict)

        session.close()

        return jsonify(all_stats)

    
    
    # ELSE: if both start and end dates were provided:
    #################################################

    # Query Prep:
    query_start_date = dt.datetime.strptime(start, "%Y-%m-%d")
    query_end_date = dt.datetime.strptime(end, "%Y-%m-%d")

    temp_sel = [func.min(Measurement.tobs),
                func.avg(Measurement.tobs),
                func.max(Measurement.tobs)]
    
    # Query:
    results = session.query(*temp_sel) \
              .filter(Measurement.date >= query_start_date) \
              .filter(Measurement.date <= query_end_date) \
              .order_by(Measurement.date)  
    
    # Create a dictionary:
    all_stats = []
    
    for tmin, tavg, tmax in results:
        stat_dict = {}
        stat_dict["TMIN"] = tmin
        stat_dict["TAVG"] = tavg
        stat_dict["TMAX"] = tmax
        all_stats.append(stat_dict)
    
    session.close()

    return jsonify(all_stats)





#################################################
#################################################

if __name__ == "__main__":
    app.run(debug=True)
