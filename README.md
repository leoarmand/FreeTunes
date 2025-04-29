<h1 align="center">
  <img src="https://fr.wikipedia.org/wiki/Note_de_musique#/media/Fichier:Audio_a.svg"/>
  <br/>
  FreeTunes
</h1>

# Project description
This is a small personal project to be able to explore and retrieve files on my Freebox using watchOS. So when I'm running I can carry on my files with me !

# Getting started
## Prerequisites
#### Freebox OS
We need to have a freebox on your network to scrap files from API

#### Install Xcode
[Installation guide](https://developer.apple.com/documentation/safari-developer-tools/installing-xcode-and-simulators)

## How to use
### Getting a session token from Freebox API
In order to use the project on your watch, you will need to first retrieve files stored on it and so to access API you need a session token.
This is a temporary token provided by Freebox OS to access data on your Freebox.
Learn more how to retrieve it by reading the [official Freebox dev API documentation](https://dev.freebox.fr/sdk/os/login/)

### password generation from challenge
Since it was a bit confusing how to retrieve the session token using app_token and challenge, I created a small python script named hmac.py at project root directory.
You can paste it's content to https://pynative.com/online-python-code-editor-to-execute-python-code/ if python is not installed on your machine.
Don't forget to replace with your token and challenge to compute the password used to create a session with the Freebox API.