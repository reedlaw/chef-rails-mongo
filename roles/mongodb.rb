name "mongodb"
description "MongoDB server"
run_list(
         "recipe[mongodb::10gen_repo]"
)
