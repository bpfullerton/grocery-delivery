from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


customers = Blueprint('customers', __name__)

# TODO: implement adding to cart
@customers.route('/addCart', methods=['POST'])
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
@customers.route('/<customerID>/cart', methods=['GET'])
def get_customer(customerId, ):
    cursor = db.get_db().cursor()
    cursor.execute('select itemName from OrderItem where orderID = (select orderID From Order where OrderedBy = {0})'.format(customerId))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
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