from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


customers = Blueprint('customers', __name__)

# adding to cart
@customers.route('/addCart', methods=['POST'])
def get_customers():
    cursor = db.get_db().cursor()
    itemName = request.form['itemName']
    quantity = request.form['quantity']
    orderId = request.form['orderId']
    query = f'insert into OrderItem (orderId, itemName, quantity, retrieved) values (\"{orderId}\", \"{itemName}\", \"{quantity}\", \"{0}\")'
    cursor.execute(query)
    db.get_db().commit()
    return "Success!"

# Get customer cart details
@customers.route('/cart', methods=['POST'])
def get_customer():
    # get a cursor object from the database
    current_app.logger.info(request.form)
    cursor = db.get_db().cursor()
    id = request.form['id']
    query = f'SELECT * FROM Orders WHERE orderedBy = \"{id}\"'
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

# Get customer cart details
@customers.route('/currentCart', methods=['POST'])
def get_customer_cart():
    # get a cursor object from the database
    current_app.logger.info(request.form)
    cursor = db.get_db().cursor()
    cart = request.form['orderId']
    query = f'SELECT * FROM OrderItem WHERE orderId = \"{cart}\"'
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
    
# add credit card
@customers.route('/addCreditCard', methods = ['POST'])
def add_cc():
    current_app.logger.info(request.form)
    cursor = db.get_db().cursor()
    number = request.form['cardNumber']
    type = request.form['cardType']
    fname = request.form['fname']
    lname = request.form['lname']
    cvc = request.form['cvc']
    customerId = request.form['customerId']
    query = f'insert into CreditCard (cardNumber, cardType, firstName, lastName, cvc) values (\"{number}\", \"{type}\", \"{fname}\", \"{lname}\", \"{cvc}\")'
    query2 = f'update Customer set creditCard = {0} where customerID = {1}'.format(number, customerId)
    cursor.execute(query)
    cursor.execute(query2)
    db.get_db().commit()
    return "Success!"

# add other payment method
@customers.route('/addPayment', methods = ['POST'])
def add_payment():
    current_app.logger.info(request.form)
    cursor = db.get_db().cursor()
    bankAccount = request.form['bankAccount']
    url = request.form['url']
    customerId = request.form['customerId']
    query = f'update Customer set bankAcctNum = {0} where customerId = {1}'.format(bankAccount, customerId)
    query2 = f'update Customer set paymentApp = {0} where customerId = {1}'.format(url, customerId)
    cursor.execute(query)
    cursor.execute(query2)
    db.get_db().commit()
    return "Success!"

    # Get all customers from the DB
@customers.route('/allStores', methods=['GET'])
def all_stores():
    cursor = db.get_db().cursor()
    cursor.execute('select storeLocation, storeId from Store')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

    # Get all customers from the DB
@customers.route('/allItems', methods=['POST'])
def all_items():
    cursor = db.get_db().cursor()
    storeID = request.form['storeID']
    cursor.execute(f'select itemName, price from Item where storeId = \"{storeID}\"')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

    # Get all customers from the DB
@customers.route('/choose', methods=['POST'])
def choose_order():
    cursor = db.get_db().cursor()
    id = request.form['customerID']
    cursor.execute(f'select orderId, total from Orders where orderedBy = \"{id}\"')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response