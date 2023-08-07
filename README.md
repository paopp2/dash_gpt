# DashGPT
A beautiful cross-platform app to chat with GPT (WIP)

Uses **BLoC** for state management 

## How to run locally:

* Create a file named ```secrets.json``` in the root of the project
* Add the following values to the file:
    * "OPEN_AI_API_KEY": [your OpenAI API key here]
* Run with either of the following:
    * Run using any of the configurations set at the ```launch.json``` file or 
    * Run with the command with ```flutter run --dart-define-from-file=secrets.json```
