import base64
import io
from flask import Flask, request, jsonify
from ultralytics import YOLO
import numpy as np
import cv2
import os

app = Flask(__name__)

# Load the trained YOLOv8 classification model
# Make sure this path is correct based on your training run
model_path = 'final model\yolov8n-cls.pt'
model = YOLO(model_path)

print("Flask app initialized and model loaded.")

@app.route('/predict', methods=['POST'])
def predict():
    if 'image' not in request.files:
        return jsonify({"error": "No image file provided"}), 400

    file = request.files['image']
    if not file.filename.lower().endswith(('.png', '.jpg', '.jpeg')):
        return jsonify({"error": "Unsupported file type. Please upload a PNG, JPG, or JPEG image."}), 400

    try:
        # Read the image file
        image_data = file.read()
        # Convert image data to a numpy array (OpenCV format)
        nparr = np.frombuffer(image_data, np.uint8)
        img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

        if img is None:
            return jsonify({"error": "Could not decode image"}), 400

        # Run inference
        results = model.predict(source=img, conf=0.25)

        # Process results
        predictions = []
        for result in results:
            names_dict = result.names
            probs = result.probs # Class probabilities

            if probs is not None:
                top_prob_index = probs.top1
                top_prob_conf = probs.top1conf.item() * 100
                predicted_class = names_dict[top_prob_index]
                predictions.append({
                    "class": predicted_class,
                    "confidence": f"{top_prob_conf:.2f}%"
                })
            else:
                predictions.append({"error": "Could not retrieve class probabilities."})

        return jsonify({
            "status": "success",
            "predictions": predictions
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500
        
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, deb