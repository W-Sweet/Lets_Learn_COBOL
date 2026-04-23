from flask import Flask, render_template, jsonify
import os

app = Flask(__name__)
app.config['SECRET_KEY'] = os.urandom(64)
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

EXAMPLES = {
    '1': {
        'left':  os.path.join(BASE_DIR, '..', 'example_0', 'ex0.cbl'),
        'right': os.path.join(BASE_DIR, '..', 'example_0', 'ex0.jcl'),
    },
    '2': {
        'left':  os.path.join(BASE_DIR, '..', 'example_1', 'ex1.cbl'),
        'right': os.path.join(BASE_DIR, '..', 'example_1', 'ex1.jcl'),
    },
    '3': {
        'left':  os.path.join(BASE_DIR, '..', 'example_2', 'ex2.cbl'),
        'right': os.path.join(BASE_DIR, '..', 'example_2', 'ex2.jcl'),
    },
    '4': {
        'left':  os.path.join(BASE_DIR, '..', 'example_3', 'ex3.cbl'),
        'right': os.path.join(BASE_DIR, '..', 'example_3', 'ex3.jcl'),
    },
}

@app.route('/')
def home():
    return render_template('webpage.html')


@app.route('/get-example/<int:num>')
def get_example(num):
    paths = EXAMPLES.get(str(num))
    if not paths:
        return jsonify({'error': 'Not found'}), 404
    result = {}
    for side, path in paths.items():
        with open(path, 'r') as f:
            result[side] = {'name': os.path.basename(path), 'content': f.read()}
    return jsonify(result)

if __name__ == '__main__':
    app.run(debug=True)