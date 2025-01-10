<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>

  <h1>[Educational] Bank Chatbot - Dart Project</h1>
  
  <p>This project is a chatbot that simulates a bank. Initially, the chatbot will present an interactive menu with the following options:</p>

  <ul>
    <li>View all accounts</li>
    <li>Add a new account</li>
    <li>Perform a transaction</li>
    <li>Exit</li>
  </ul>

  <p><strong>Project Objective:</strong></p>
  <p>The main goal of this project is to understand key concepts in Dart programming, including:</p>
  <ul>
    <li>Asynchronous programming</li>
    <li>Object-Oriented Programming (OOP)</li>
    <li>Null Safety</li>
    <li>API requests using HTTP</li>
  </ul>

  <p>The chatbot allows users to simulate various banking actions while exploring these core Dart features. It is a hands-on project to improve skills in Dart and its application in real-world scenarios.</p>

  <h2>Technologies Used:</h2>
  <ul>
    <li>Dart</li>
    <li>Async Programming</li>
    <li>Object-Oriented Programming (OOP)</li>
    <li>Null Safety</li>
    <li>HTTP Requests</li>
  </ul>

  <h2>Getting Started:</h2>
  <p>Clone the repository and follow these steps to get the project running:</p>
  <ol>
    <li>The application will simulate a bank using Gist as a data source. To get started, you need to create two Gists on GitHub:</li>
    <ul>
      <li><strong>accounts.json</strong> - Gist for storing account data.</li>
      <li><strong>transactions.json</strong> - Gist for storing transaction data.</li>
    </ul>
    <li>After creating the Gists, add their respective Gist IDs to the <strong>services/api_endpoint.dart</strong> file.</li>
    <li>Additionally, you need to insert your GitHub authorization token into the <strong>api_key.dart</strong> file to allow the application to interact with the Gists.</li>
  </ol>
  
  <p>Once you've set up the Gists and the configuration files, run the application to interact with the chatbot and explore the banking features. The chatbot will retrieve and update the account and transaction data from the Gists during the simulation.</p>
</body>
</html>
