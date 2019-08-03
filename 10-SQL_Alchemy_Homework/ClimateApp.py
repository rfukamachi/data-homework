# 1. import Flask
#################################################
from flask import Flask, jsonify

# 2. Create an app, being sure to pass __name__
#################################################
app = Flask(__name__)


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
        f"Here are the available routes:<br/>"
        f"/api/v1.0/precipitation<br/>"
        f"/api/v1.0/stations<br/>"
        f"/api/v1.0/tobs<br/>"
        f"/api/v1.0/<start><br/>"
        f"/api/v1.0/<start>/<end><br/>"
        f"<br/>"
        f"<br/>"
    )
    



#################################################
# * `/api/v1.0/precipitation`
#   * Convert the query results to a Dictionary using `date` as the key and `prcp` as the value.
#   * Return the JSON representation of your dictionary.
#################################################








#################################################
# * `/api/v1.0/stations`
#   * Return a JSON list of stations from the dataset.
#################################################







#################################################
# * `/api/v1.0/tobs`
#   * query for the dates and temperature observations from a year from the last data point.
#   * Return a JSON list of Temperature Observations (tobs) for the previous year.
#################################################






#################################################
# * `/api/v1.0/<start>` and `/api/v1.0/<start>/<end>`
#   * Return a JSON list of the minimum temperature, the average temperature, and the max temperature for a given start or start-end range.
#   * When given the start only, calculate `TMIN`, `TAVG`, and `TMAX` for all dates greater than and equal to the start date.
#   * When given the start and the end date, calculate the `TMIN`, `TAVG`, and `TMAX` for dates between the start and end date inclusive.
#################################################






#################################################
#################################################







#################################################
#################################################









#################################################
#################################################
#################################################
#################################################
#################################################

# 4. Define what to do when a user hits the /about route
@app.route("/about")
def about():
    print("Server received request for 'About' page...")
    return "Welcome to my 'About' page!"


if __name__ == "__main__":
    app.run(debug=True)
