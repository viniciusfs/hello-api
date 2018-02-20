import datetime
import random

from flask import Flask, jsonify, request


application = Flask(__name__)

HELLO = [ 'bonjour', 'hola', 'hallo', 'hello', 'ciao', 'ola', 'namaste', 'salaam' ]

@application.route('/', methods=['GET', 'POST'])
def hello():
    now = datetime.datetime.now()
    hello = random.choice(HELLO)

    if not request.json:
        return jsonify({'hello': hello, 'datetime': now}), 200
    else:
        return jsonify({'hello': request.json['name'], 'datetime': now}), 200


if __name__ == '__main__':
    application.run(debug=True)
