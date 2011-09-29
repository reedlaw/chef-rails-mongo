maintainer       "Reed Law"
maintainer_email "reed@smashingboxes.com"
license          'Apache v2.0'
description      "Installs/Configures rails"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

%w{ unicorn }.each do |cb|
  depends cb
end
