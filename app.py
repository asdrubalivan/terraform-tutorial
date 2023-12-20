from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text
import os
app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://exampleuser:examplepass@postgres/exampledb'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

@app.route('/')
def hello_world():
    return 'Hello, World!'

@app.route('/get-time')
def get_time():
    with db.engine.connect() as conn:
      result = conn.execute(text('SELECT NOW()'))
    current_time = result.fetchone()[0]
    return {'current_time': str(current_time)}

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)

