current_dir = File.dirname(__FILE__)
user = ENV['OPSCODE_USER']
log_level                :info
log_location             STDOUT
node_name                user
client_key               "#{ENV['HOME']}/.chef/#{user}.pem"
validation_client_name   "#{ENV['ORGNAME']}-validator"
validation_key           "#{ENV['HOME']}/.chef/#{ENV['ORGNAME']}-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/#{ENV['ORGNAME']}"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]

knife[:aws_access_key_id]     = ENV['AWS_ACCESS_KEY_ID']
knife[:aws_secret_access_key] = ENV['AWS_SECRET_ACCESS_KEY']
knife[:identity_file]         = "#{ENV['HOME']}/.ec2/ampms"
knife[:aws_ssh_key_id]        = ENV['AWS_SSH_KEY_ID']

knife[:availability_zone] = "us-east-1a"
knife[:region]            = "us-east-1"
knife[:aws_image_id]      = "ami-81b275e8"
