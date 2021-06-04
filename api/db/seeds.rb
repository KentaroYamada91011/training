# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Task.create(user_id: 1, title: "サンプルプロジェクト", description: "サンプル", deadline: "2021-05-31 10:21:32", status: 10, parent_id: 0)
