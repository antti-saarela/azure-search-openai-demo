# Demo App Analysis using OpenAI with GPT-4

The provided code is a Python Flask app that utilizes the Azure Cognitive Search, Azure Blob Storage, and OpenAI API to create an AI assistant. The code includes several approaches for integrating GPT and external knowledge, such as Retrieve Then Read (RTR), Read Retrieve Read (RRR), and Read Decompose Ask (RDA).

The Flask app has the following routes:
/ - Serves the static files in the application.
/content/<path> - Serves content files from the Azure Blob Storage.
/ask - Takes a POST request with a JSON payload containing the question and approach, and returns the AI-generated response based on the selected approach.
/chat - Takes a POST request with a JSON payload containing the chat history and approach, and returns the AI-generated response based on the selected approach.

To use this Flask app, you should have the necessary Azure services and OpenAI API credentials set up. Replace the placeholder values for the Azure Storage Account, Azure Storage Container, Azure Search Service, Azure Search Index, and Azure OpenAI Service with your own values.

The app uses the DefaultAzureCredential for authentication, which means you can use az login locally or Managed Identity when deployed on Azure. If you need to use keys, you can use separate AzureKeyCredential instances with the keys for each service.

Once you have set up the necessary services and credentials, you can run the Flask app by executing the Python script. It will start the app on the default Flask development server, and you can access it via your web browser at http://localhost:5000.
