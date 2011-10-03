name "chef-rails-mongo"
description "chef rails mongo example app"
run_list(
         "recipe[ruby@0.0.1]",
         "recipe[nginx@0.0.1]",
         "recipe[node]",
         "recipe[node::npm]",
         "recipe[unicorn]",
         "recipe[rails@0.0.1]"
)
