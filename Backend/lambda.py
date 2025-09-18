import boto3
import json
import uuid
import os
 
# AWS clients
polly = boto3.client("polly")
s3 = boto3.client("s3")

# S3 bucket name from environment variable
BUCKET_NAME = os.environ.get('AUDIO_BUCKET_NAME')
 
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
        
        # Generate unique filename
        filename = f"audio/{uuid.uuid4()}.mp3"
        
        # Upload to S3
        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=filename,
            Body=audio_data,
            ContentType="audio/mpeg"
        )
        
        # Generate presigned URL (valid for 1 hour)
        url = s3.generate_presigned_url(
            'get_object',
            Params={'Bucket': BUCKET_NAME, 'Key': filename},
            ExpiresIn=3600
        )
        
        return {
            "statusCode": 200,
            "headers": headers,
            "body": json.dumps({
                "url": url,
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