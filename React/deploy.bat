@echo off
echo Building React app...
npm run build

echo Uploading to S3...
aws s3 sync build/ s3://text-to-speech-frontend-ce93d859 --delete

echo Invalidating CloudFront cache...
aws cloudfront create-invalidation --distribution-id E2AZLNCMO2N5FA --paths "/*"

echo Deployment complete!