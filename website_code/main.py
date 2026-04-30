from flask import Flask, render_template, jsonify, request
import os
import json

app = Flask(__name__)
app.config['SECRET_KEY'] = os.urandom(64)
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
GLOSSARY_FILE = os.path.join(BASE_DIR, 'glossary.json')

# Initialize glossary file if it doesn't exist
if not os.path.exists(GLOSSARY_FILE):
    initial_data = {
        'IDENTIFICATION': 'Starts the Identification Division.',
        'PROGRAM-ID': 'Names the program.',
        'PROCEDURE': 'Contains the program logic.'
    }
    with open(GLOSSARY_FILE, 'w') as f:
        json.dump(initial_data, f, indent=4)

EXAMPLES = {
    '1': {'left': os.path.join(BASE_DIR, '..', 'example_0', 'ex0.cbl'), 'right': os.path.join(BASE_DIR, '..', 'example_0', 'ex0.jcl')},
    '2': {'left': os.path.join(BASE_DIR, '..', 'example_1', 'ex1.cbl'), 'right': os.path.join(BASE_DIR, '..', 'example_1', 'ex1.jcl')},
    '3': {'left': os.path.join(BASE_DIR, '..', 'example_2', 'ex2.cbl'), 'right': os.path.join(BASE_DIR, '..', 'example_2', 'ex2.jcl')},
    '4': {'left': os.path.join(BASE_DIR, '..', 'example_3', 'ex3.cbl'), 'right': os.path.join(BASE_DIR, '..', 'example_3', 'ex3.jcl')},
}

@app.route('/')
def home():
    return render_template('webpage.html')

@app.route('/get-keywords')
def get_keywords():
    with open(GLOSSARY_FILE, 'r') as f:
        return jsonify(json.load(f))

@app.route('/update-keywords', methods=['POST'])
def update_keywords():
    try:
        new_glossary = request.json
        with open(GLOSSARY_FILE, 'w') as f:
            json.dump(new_glossary, f, indent=4)
        return jsonify({'status': 'success'})
    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)}), 500

@app.route('/get-example/<int:num>')
def get_example(num):
    paths = EXAMPLES.get(str(num))
    if not paths:
        return jsonify({'error': 'Not found'}), 404
    result = {}
    for side, path in paths.items():
        try:
            with open(path, 'r') as f:
                result[side] = {'name': os.path.basename(path), 'content': f.read()}
        except FileNotFoundError:
            result[side] = {'name': 'Missing', 'content': 'File not found.'}
    return jsonify(result)

if __name__ == '__main__':
    app.run(debug=True)