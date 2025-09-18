# Text-to-Speech Application

A modern, cloud-based text-to-speech application built with React and AWS services.

## 🎯 Features

- **Text-to-Speech Conversion**: Convert any text to natural-sounding speech
- **Multiple Voices**: Choose from 4 different AWS Polly voices (US & UK accents)
- **Audio Download**: Download generated audio files as MP3
- **Responsive Design**: Clean, modern interface that works on all devices
- **Cloud-Powered**: Fully serverless architecture using AWS services

## 🏗️ Architecture

### Frontend
- **React.js**: Modern web application framework
- **CloudFront**: Global content delivery network
- **S3**: Static website hosting

### Backend
- **API Gateway**: RESTful API with CORS support
- **Lambda**: Serverless compute for text processing
- **Polly**: AI-powered text-to-speech service
- **S3**: Audio file storage with presigned URLs

## 🚀 Deployment

### Prerequisites
- AWS CLI configured
- Terraform installed
- Node.js and npm installed

### Backend Deployment
```bash
cd Backend
terraform init
terraform apply
```

### Frontend Infrastructure
```bash
cd Frontend
terraform init
terraform apply
```

### React Application
```bash
cd React
npm install
npm run build
deploy.bat
```

## 🎵 Available Voices

- **Joanna** (US Female)
- **Matthew** (US Male)
- **Amy** (UK Female)
- **Brian** (UK Male)

## 🔧 Configuration

The application uses environment variables for configuration:
- `REACT_APP_API_URL`: API Gateway endpoint
- `AUDIO_BUCKET_NAME`: S3 bucket for audio storage

## 📁 Project Structure

```
Capstone_project/
├── Backend/           # AWS Lambda & API Gateway
├── Frontend/          # S3 & CloudFront infrastructure
├── React/            # React application
└── README.md         # This file
```

## 🌐 Live Application

Access the application at your CloudFront distribution URL after deployment.

## 👨‍💻 Developer

**Jonathan's AI Voice Studio** - A capstone project demonstrating modern cloud architecture and AI integration.

---

*Built with ❤️ using AWS, React, and Terraform*