import datetime
import random

from flask import Flask, jsonify, request


application = Flask(__name__)

COUNTRIES = [ 'brazil', 'usa', 'canada', 'japan', 'england', 'china', 'india' ]

@app.route('/api/v1/hello', methods=['GET', 'POST'])
def hello():
    now = datetime.datetime.now()
    country = random.choice(COUNTRIES)

    if not request.json:
        return jsonify({'hello': country, 'datetime': now}), 200
    else:
        return jsonify({'hello': request.json['name'], 'datetime': now}), 200


if __name__ == '__main__':
    application.run(debug=True)
