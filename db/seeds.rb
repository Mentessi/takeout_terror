# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user1 = User.find_or_create_by_email :first_name => 'first', :last_name => 'user', :email => 'user1@example.com', :password => 'password', :password_confirmation => 'password'
puts 'user: ' << user1.first_name

user2 = User.find_or_create_by_email :first_name => 'second', :last_name => 'user', :email => 'user2@example.com', :password => 'password', :password_confirmation => 'password'
puts 'user: ' << user2.first_name

user3 = User.find_or_create_by_email :first_name => 'third', :last_name => 'user',:email => 'user3@example.com', :password => 'password', :password_confirmation => 'password'
puts 'user: ' << user3.first_name