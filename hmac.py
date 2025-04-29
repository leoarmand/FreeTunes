import hashlib
 import hmac
 
 def get_password():
     TOKEN = 'YOUR_TOKEN'
     CHALLENGE = '53JgumwJkvC7+TfbDRg5fqSmvnjzsHkf'
     token_bytes = bytes(TOKEN, 'latin-1')
     challenge_bytes = bytes(CHALLENGE, 'latin-1')
     password = hmac.new(token_bytes, challenge_bytes, hashlib.sha1).hexdigest()
     print(password)
     return password
 
 get_password()
