# Grocery Store Delivery App

This repo contains the database and code for a grocery store ordering and delivery/pickup system. This app's goal is to:
1. Allow customers to place an online order by choosing from a store's stock and inputting their payment and delivery information, and monitor the orders they've made
1. Allow employees who deliver the orders to view order and customer information, and claim responsibility for taking those orders
1. Allow the store managers to control the employees' hours and pay, change items' prices, and update items' stock

**NOTE: This app routes to port 8001.**

## App Structure & Personas

This app has three user personas: Customer, Employee, and Manager.
* The customer is the one who places an order, consisting of a collection of store items and a total price. They can indicate whether they would like their order to be delivered or marked for them to pick up. To place an order, they must first enter their customer ID (a login credential), add items to their cart, and input their address and payment information. They can choose to pay with either a credit card, bank account, or a link to their account on a payment app such as PayPal or Venmo. While they can only have one of each method linked, they can update them or add any methods they don't yet have. Once they've paid for an order, they can view the status and other information of their other orders (a customer can have multiple separate orders placed).
* The employee is the one who takes and handles one or more orders. By entering their employee ID, the employee can view the different orders they've claimed, and can mark those orders as complete. This might translate to a real-world application, as the amount of orders an employee completes can reflect on their performance.
* The manager of a store has the most power when it comes to changing the store's data. In this version of the app, they have the ability to add items to a store's stock, with the ability to set the price of the item and the quantity of that item in the store. They must also specify the store number whose data they are updating.



