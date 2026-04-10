from flask import Flask, session, url_for, redirect, request, render_template, jsonify 
import os 
import random

app = Flask(__name__)
app.config['SECRET_KEY'] = os.urandom(64)

@app.route('/')
def home(): 
    return render_template('webpage.html')

if __name__ == '__main__':    app.run(debug=True)