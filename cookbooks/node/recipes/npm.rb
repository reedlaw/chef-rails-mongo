remote_file "/tmp/npm-install.sh" do
  source "http://npmjs.org/install.sh"
end

execute "npm-install" do
  command "clean=no sh /tmp/npm-install.sh"
  not_if "which npm"
end
