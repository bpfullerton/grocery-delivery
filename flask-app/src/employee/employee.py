from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


employee = Blueprint('employee', __name__)

# Get carts assigned to employee
@employee.route('/id', methods=['POST'])
def get_id():
    # get a cursor object from the database
    current_app.logger.info(request.form)
    cursor = db.get_db().cursor()
    id = request.form['id']
    query = f'SELECT * FROM Orders WHERE fulfilledBy = \"{id}\"'
    cursor.execute(query)
       # grab the column headers from the returned data
    column_headers = [x[0] for x in cursor.description]

    # create an empty dictionary object to use in 
    # putting column headers together with data
    json_data = []

    # fetch all the data from the cursor
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response