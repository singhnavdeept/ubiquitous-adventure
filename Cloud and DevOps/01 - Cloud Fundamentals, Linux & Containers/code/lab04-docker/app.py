from flask import Flask, jsonify
import socket
import datetime

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({
        "course": "INT378: Advancements in Cloud and DevOps",
        "lab": "Lab 04: Docker Architecture & Lifecycle",
        "status": "online",
        "container_hostname": socket.gethostname(),
        "timestamp": datetime.datetime.utcnow().isoformat() + "Z"
    })

@app.route('/health')
def health():
    return jsonify({"status": "healthy", "code": 200})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
