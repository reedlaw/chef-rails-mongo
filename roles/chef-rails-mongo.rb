name "chef-rails-mongo"
description "chef rails mongo example app"
run_list(
         "recipe[ruby@0.0.1]",
         "recipe[nginx@0.0.1]",
         "recipe[unicorn]",
         "recipe[rails]"
)
