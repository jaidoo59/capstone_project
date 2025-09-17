import boto3
import json
import base64
 
# AWS Polly client
polly = boto3.client("polly")
 
def lambda_handler(event, context):
    # CORS headers
    headers = {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "Content-Type",
        "Access-Control-Allow-Methods": "OPTIONS,POST,GET"
    }
    try:
        # Parse request body
        if event.get('body'):
            body = json.loads(event['body'])
        else:
            body = event
        text = body.get("text", "Hello World")
        voice = body.get("voice", "Joanna")  # Default English voice
        # Synthesize plain text
        response = polly.synthesize_speech(
            Text=text,
            TextType="text",
            OutputFormat="mp3",
            VoiceId=voice
        )
        # Read audio data
        audio_data = response["AudioStream"].read()
        # Return audio + original text
        return {
            "statusCode": 200,
            "headers": headers,
            "body": json.dumps({
                "audio": base64.b64encode(audio_data).decode('utf-8'),
                "originalText": text,
                "voiceUsed": voice
            })
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "headers": headers,
            "body": json.dumps({"error": str(e)})
        }