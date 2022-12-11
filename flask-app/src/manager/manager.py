from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

manager = Blueprint('manager', __name__)

@manager.route('/addItem', methods = ['POST'])
def add_item():
    current_app.logger.info(request.form)
    cursor = db.get_db().cursor()
    itemName = request.form['item_name']
    storeID = request.form['store_num']
    price = request.form['price']
    stock = request.form['stock']
    query = f'insert into Item (itemName, storeId, price, stock) values(\"{itemName}\", \"{storeID}\", \"{price}\", \"{stock}\"'
    cursor.execute(query)
    db.get_db().commit()
    return "Success!"