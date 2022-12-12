from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


customers = Blueprint('customers', __name__)

# Get all customers from the DB
@customers.route('/customers', methods=['GET'])
def get_customers():
    cursor = db.get_db().cursor()
    cursor.execute('select customerNumber, customerName,\
        creditLimit from customers')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get customer cart details
@customers.route('/customers/cart', methods=['GET'])
def get_customer(userID):
    cursor = db.get_db().cursor()
    cursor.execute('select * from customers where customerNumber = {0}'.format(userID))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

    
@customers.route('/addCreditCard', methods = ['POST'])
def add_item():
    current_app.logger.info(request.form)
    cursor = db.get_db().cursor()
    number = request.form['cardNumber']
    type = request.form['cardType']
    fname = request.form['fname']
    lname = request.form['lname']
    cvc = request.form['cvc']
    query = f'insert into CreditCard (cardNumber, cardType, firstName, lastName, cvc) values (\"{number}\", \"{type}\", \"{fname}\", \"{lname}\", \"{cvc}\")'
    query2 = f'update Customer set creditCard = \"{number}\" where firstName = \"{fname}\" and lastName = \"{lname}\"'
    cursor.execute(query)
    cursor.execute(query2)
    db.get_db().commit()
    return "Success!"