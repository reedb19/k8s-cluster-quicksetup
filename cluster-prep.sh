export NAME=reedfleetman.k8s.local
export S3_BUCKET=reedfleetman-state-store
export KOPS_STATE_STORE=s3://reedfleetman-state-store

echo "creating bucket.."
aws s3api create-bucket --bucket $S3_BUCKET --region us-east-1 | awk '/Location/{print "Bucket name: " $2}' | tr -d '"./'
echo "Bucket created"
aws s3api put-bucket-versioning --bucket $S3_BUCKET  --versioning-configuration Status=Enabled
aws s3api put-bucket-encryption --bucket $S3_BUCKET --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'
echo "Creating cluster"
kops create cluster --zones=ap-south-1a,ap-south-1b,ap-south-1c --master-size t3.medium --master-count 1 --node-size t3.small --node-count 2 ${NAME}

