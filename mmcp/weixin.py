# coding=utf-8
import os.path
import ConfigParser
import requests
import json
import ConfigParser

PROJECT_ROOT = os.path.abspath(os.path.dirname(__file__))

_config = ConfigParser.RawConfigParser()
_config.read(PROJECT_ROOT + '\weixin.ini')

def get_corp_id():
    return _config.get("weixin", "CorpID")

def get_secret():
    return _config.get("weixin", "Secret")

def get_token_url():
    return _config.get("weixin", "TokenUrl")    
    
def get_send_message_url():
    return _config.get("weixin", "SendMessageUrl")  
    
def get_agent_id():
    return _config.getint("weixin", "agentId")  
    
         
def get_access_token():
    access_token = None
    corpId = get_corp_id()
    secret = get_secret()
    tokenUrl = get_token_url()
    payload = {'corpid': corpId, 'corpsecret': secret}
    r = requests.get(tokenUrl, params=payload)
    content = r.json()
    if "access_token" in content:
        access_token = content['access_token']
    
    return access_token

    

def build_text_message(user_id, content):
    message = {}
    message['msgtype'] = "text"
    message['agentid'] = get_agent_id()
    message['touser'] = user_id
    text = {}
    text['content'] = str(content)
    message['text'] = text
    return json.dumps(message, ensure_ascii=False)

def post_message(message, access_token):
    sendMsgUrl = get_send_message_url() + "?access_token=" + access_token
    response = requests.post(sendMsgUrl, data=message)
    print response.text
    
def send_message(user_id, content): 
    access_token = get_access_token()
    if access_token:
        message = build_text_message(user_id, content)
        post_message(message,access_token )

