require "refile/s3"

aws = {
  access_key_id: "AKIAIVJ5X7LNREKDIWXQ",
  secret_access_key: "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",
  region: "us-west-2",
  bucket: "tails-dev",
  max_size: 5.megabytes
}
Refile.cache = Refile::S3.new(prefix: "cache", **aws)
Refile.store = Refile::S3.new(prefix: "store", **aws)
