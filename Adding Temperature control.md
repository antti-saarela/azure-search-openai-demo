# Adding Temperature control

To add a dropdown menu for selecting the temperature, you'll need to make changes to both the frontend and backend of the Flask app. Here's a step-by-step guide to achieve this:
Modify the frontend (HTML) to include a dropdown menu for selecting the temperature. In your templates folder (create one if you don't have it), create a new file called index.html and add the following code:

```
<!DOCTYPE html>  
<html lang="en">  
<head>  
    <meta charset="UTF-8">  
    <meta name="viewport" content="width=device-width, initial-scale=1.0">  
    <title>AI Assistant</title>  
</head>  
<body>  
    <h1>AI Assistant</h1>  
  
    <label for="temperature">Temperature:</label>  
    <select id="temperature">  
        <option value="0">0</option>  
        <option value="0.1">0.1</option>  
        <option value="0.2">0.2</option>  
        <!-- Add the rest of the options up to 1.0 -->  
    </select>  
  
    <!-- Add your existing form elements and JavaScript code here -->  
  
</body>  
</html>  
```

2. Update the JavaScript code to store the selected temperature value and use it when making requests to the /ask and /chat endpoints. In the 
`<script>` section of your index.html file, add the following code:

```
document.getElementById("temperature").addEventListener("change", function() {  
    localStorage.setItem("temperature", this.value);  
});  
  
function getTemperature() {  
    return localStorage.getItem("temperature") || "0.1";  
}  
  
// Update your existing AJAX calls to the /ask and /chat endpoints to include the temperature value:  
  
// Example for /ask:  
fetch("/ask", {  
    method: "POST",  
    headers: {  
        "Content-Type": "application/json"  
    },  
    body: JSON.stringify({  
        question: yourQuestionVariable,  
        approach: yourApproachVariable,  
        overrides: {  
            "temperature": parseFloat(getTemperature())  
        }  
    })  
})  
.then(response => response.json())  
.then(data => {  
    // Process the response  
});  
  
// Example for /chat:  
fetch("/chat", {  
    method: "POST",  
    headers: {  
        "Content-Type": "application/json"  
    },  
    body: JSON.stringify({  
        history: yourHistoryVariable,  
        approach: yourApproachVariable,  
        overrides: {  
            "temperature": parseFloat(getTemperature())  
        }  
    })  
})  
.then(response => response.json())  
.then(data => {  
    // Process the response  
});  

```

3. Update the backend (Python) to accept the temperature value in the JSON payload and use it when making calls to the OpenAI API. Modify the /ask and /chat routes in your Flask app to include the temperature override:


```
@app.route("/ask", methods=["POST"])  
def ask():  
    ensure_openai_token()  
    approach = request.json["approach"]  
    temperature = request.json["overrides"].get("temperature")  
    overrides = {"temperature": temperature} if temperature is not None else {}  
    try:  
        impl = ask_approaches.get(approach)  
        if not impl:  
            return jsonify({"error": "unknown approach"}), 400  
        r = impl.run(request.json["question"], overrides)  
        return jsonify(r)  
    except Exception as e:  
        logging.exception("Exception in /ask")  
        return jsonify({"error": str(e)}), 500  
      
@app.route("/chat", methods=["POST"])  
def chat():  
    ensure_openai_token()  
    approach = request.json["approach"]  
    temperature = request.json["overrides"].get("temperature")  
    overrides = {"temperature": temperature} if temperature is not None else {}  
    try:  
        impl = chat_approaches.get(approach)  
        if not impl:  
            return jsonify({"error": "unknown approach"}), 400  
        r = impl.run(request.json["history"], overrides)  
        return jsonify(r)  
    except Exception as e:  
        logging.exception("Exception in /chat")  
        return jsonify({"error": str(e)}), 500  
  
 ```


With these changes, the Flask app will now accept the temperature value from the frontend and use it as an override when making calls to the OpenAI API.

