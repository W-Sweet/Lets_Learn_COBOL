from flask import Flask, render_template, jsonify
import os

app = Flask(__name__)
app.config['SECRET_KEY'] = os.urandom(64)

EXAMPLES = {
    '1': 'example_1/intro.txt',
    '2': 'example_2/ex2.txt',
    '3': 'example_3/ex3.txt'
}

@app.route('/')
def home():
    return render_template('webpage.html')

@app.route('/get-example/<int:num>')
def get_example(num):
    path = EXAMPLES.get(str(num))
    if not path:
        return jsonify({'error': 'Not found'}), 404
    with open(path, 'r') as f:
        return jsonify({'content': f.read()})

if __name__ == '__main__':
    app.run(debug=True)