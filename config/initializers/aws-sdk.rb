
if false && Rails.env == "development"
require 'json'
require 'aws-sdk-s3'
require "open-uri"

# S3 SETUP
Aws.config.update(
  credentials: Aws::Credentials.new(ENV["AWS_ACCESS_KEY_ID"], ENV["AWS_SECRET_ACCESS_KEY"]),
  region: ENV["AWS_REGION"],
)

# CLOUDFRONT SETUP

s3 = Aws::S3::Resource.new

bucket_name = ENV["CLOUDFRONT_BUCKET"]
private_key_path = "private_key.pem"

obj = s3.bucket(bucket_name).object(private_key_path).get(response_target: (Rails.root+"/private_key.pem"))

AWS_SIGNER = Aws::CloudFront::UrlSigner.new(
  key_pair_id: ENV["CLOUDFRONT_PUBLIC_KEY"],
  private_key_path: (Rails.root+"/private_key.pem")
)

CLOUDFRONT_ROOT = ENV["CLOUDFRONT_ROOT"]

AWS_BUCKET = ENV["AWS_BUCKET"]

# UPLOAD
S3_BUCKET = Aws::S3::Resource.new.bucket(ENV['AWS_BUCKET'])


elsif false


require 'json'
require 'aws-sdk-s3'
require "open-uri"

# S3 SETUP
Aws.config.update(
  credentials: Aws::Credentials.new(ENV["AWS_ACCESS_KEY_ID"], ENV["AWS_SECRET_ACCESS_KEY"]),
  region: ENV["AWS_REGION"],
)

# CLOUDFRONT SETUP

s3 = Aws::S3::Resource.new

bucket_name = ENV["CLOUDFRONT_BUCKET"]
private_key_path = "private_key.pem"

obj = s3.bucket(bucket_name).object(private_key_path).get(response_target: ("/tmp/private_key.pem"))

AWS_SIGNER = Aws::CloudFront::UrlSigner.new(
  key_pair_id: ENV["CLOUDFRONT_PUBLIC_KEY"],
  private_key_path: ("/tmp/private_key.pem")
)

CLOUDFRONT_ROOT = ENV["CLOUDFRONT_ROOT"]

AWS_BUCKET = ENV["AWS_BUCKET"]

# UPLOAD
S3_BUCKET = Aws::S3::Resource.new.bucket(ENV['AWS_BUCKET'])
end