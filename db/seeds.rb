# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user1 = User.find_or_create_by_email :name => 'first person', :email => 'user1@example.com', :password => 'password', :password_confirmation => 'password'
puts 'user: ' << user1.name

user2 = User.find_or_create_by_email :name => 'second person', :email => 'user2@example.com', :password => 'password', :password_confirmation => 'password'
puts 'user: ' << user2.name

user3 = User.find_or_create_by_email :name => 'third person', :email => 'user3@example.com', :password => 'password', :password_confirmation => 'password'
puts 'user: ' << user3.name

establishment1 = Establishment.create(
    fhrsid: 103210,
    local_authority_business_id: "34599",
    business_name: "Nandos Chicken",
    business_type: "Restaurant/Cafe/Canteen",
    business_type_id: "1",
    address_line_1: "Eastgate Food Terrace",
    address_line_2: "Eastgate Centre",
    address_line_3: "Basildon",
    address_line_4: "Essex",
    postcode: "SS14 1AF",
    rating_value: 5,
    rating_key: "fhrs_5_en-GB",
    rating_date: DateTime.new(2011,11,25),
    local_authority_code: "109",
    local_authority_name: "Basildon",
    local_authority_website: "http://www.basildon.gov.uk",
    local_authority_email_address: "ehs@basildon.gov.uk",
    scores_hygiene: 0,
    scores_structual: 0,
    scores_confidence_in_management: 0,
    scheme_type: "FHRS",
    Geocode_Longitude: 4.603730000000000e-001,
    Geocode_Latitude: 5.156951500000000e+001)

visit1 = Visit.create(user_id: user1.id, establishment_id: establishment1.id, fs_rating_value: 5)

visit2 = Visit.create(user_id: user2.id, establishment_id: establishment1.id, fs_rating_value: 0)

visit3 = Visit.create(user_id: user3.id, establishment_id: establishment1.id, fs_rating_value: 2)

zero_rating_badge = Badge.create(name: "Zero", description: "zero rated", type: "ZeroRatingBadge")