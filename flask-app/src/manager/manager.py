from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

manager = Blueprint('manager', __name__)

@manager.route('/addItem', methods = ['POST'])
def add_item():
    current_app.logger.info(request.form)
    cursor = db.get_db().cursor()
    itemName = request.form['itemName']
    storeID = request.form['storeID']
    price = request.form['price']
    stock = request.form['stock']
    query = f'INSERT INTO Item (itemName, storeId, price, stock) VALUES(\"{itemName}\", \"{storeID}\", \"{price}\", \"{stock}\")'
    cursor.execute(query)
    db.get_db().commit()
    return "Success!"

# Get all customers from the DB
@manager.route('/allItems', methods=['GET'])
def get_items():
    cursor = db.get_db().cursor()
    cursor.execute('select itemName, price,\
        stock from Item')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response