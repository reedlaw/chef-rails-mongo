name "chef-rails-mongo"
description "chef rails mongo example app"
run_list(
         "recipe[ruby]",
         "recipe[nginx]"
)
