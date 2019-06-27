# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# user = User.create!(
#   name: 'User-name',
#   email: 'test@example.com',
#   email_confirmation: 'test@example.com',
#   role: User.roles[:management],
# )

user = User.find_or_create_by!(email: 'test@example.com') do |create_user|
  create_user.name = 'User-name'
  create_user.email_confirmation = 'test@example.com'
  create_user.role = User.roles[:management]
end

if user.user_credential.blank?
  user_credential = UserCredential.new(user: user, password_digest: BCrypt::Password.create('123456'))
  user_credential.save!(validate: false)
end

Label.find_or_create_by!(name: '遊び')
Label.find_or_create_by!(name: '寝る')
Label.find_or_create_by!(name: '食べる')
Label.find_or_create_by!(name: '映画')
Label.find_or_create_by!(name: '旅行')
Label.find_or_create_by!(name: '掃除')
Label.find_or_create_by!(name: '仕事')
Label.find_or_create_by!(name: 'ダイエット')
Label.find_or_create_by!(name: 'ジム')
