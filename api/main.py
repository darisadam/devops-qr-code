from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import qrcode
import boto3
import os
from io import BytesIO

# Loading Environment variable (AWS Access Key and Secret Key)
from dotenv import load_dotenv
load_dotenv()

app = FastAPI()

# Allowing CORS for local testing
origins = [
    "http://localhost:3000"
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_methods=["*"],
    allow_headers=["*"],
)

# AWS S3 Configuration
s3 = boto3.client(
    's3',
    endpoint_url=os.getenv("S3_ENDPOINT_URL", "http://localhost:9090"),
    aws_access_key_id= os.getenv("AWS_ACCESS_KEY", "test"),
    aws_secret_access_key= os.getenv("AWS_SECRET_KEY", "test"),
    config=boto3.session.Config(signature_version='s3v4')
)

# Fix for Adobe S3 Mock: Disable "Expect: 100-continue" header which causes connection resets
def disable_expect_header(request, **kwargs):
    if 'Expect' in request.headers:
        del request.headers['Expect']

s3.meta.events.register('before-send.s3.PutObject', disable_expect_header)

bucket_name = 'my-bucket'

@app.get("/")
def read_root():
    return {"message": "QR Code API is running!"}

@app.post("/generate-qr/")
async def generate_qr(url: str):
    # Generate QR Code
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(url)
    qr.make(fit=True)

    img = qr.make_image(fill_color="black", back_color="white")
    
    # Save QR Code to BytesIO object
    img_byte_arr = BytesIO()
    img.save(img_byte_arr, format='PNG')
    img_byte_arr.seek(0)

    # Generate file name for S3
    file_name = f"qr_codes/{url.split('//')[-1]}.png"

    try:
        try:
            print(f"Attempting to create bucket {bucket_name} on {s3.meta.endpoint_url}")
            s3.create_bucket(Bucket=bucket_name)
            print("Bucket created successfully")
        except Exception as e:
            print(f"Bucket creation skipped/failed: {e}")

        # Upload to S3
        print(f"Uploading {file_name} to S3...")
        s3.put_object(Bucket=bucket_name, Key=file_name, Body=img_byte_arr, ContentType='image/png')
        print("Upload successful")

        
        # Generate the S3 URL
        # Use S3_PUBLIC_URL if set -> S3_ENDPOINT_URL -> default localhost
        public_url = os.getenv("S3_PUBLIC_URL", os.getenv("S3_ENDPOINT_URL", "http://localhost:9090"))
        s3_url = f"{public_url}/{bucket_name}/{file_name}"
        return {"qr_code_url": s3_url}
    except Exception as e:
        print(f"Error: {e}")
        raise HTTPException(status_code=500, detail=str(e))
    