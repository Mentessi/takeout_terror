# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :establishment do
    fhrsid 103210
    local_authority_business_id "34599"
    business_name "Nandos Chicken"
    business_type "Restaurant/Cafe/Canteen"
    business_type_id "1"
    address_line_1 "Eastgate Food Terrace"
    address_line_2 "Eastgate Centre"
    address_line_3 "Basildon"
    address_line_4 "Essex"
    postcode "SS14 1AF"
    rating_value 5
    rating_key "fhrs_5_en-GB"
    rating_date DateTime.new(2011,11,25)
    local_authority_code "109"
    local_authority_name "Basildon"
    local_authority_website "http://www.basildon.gov.uk"
    local_authority_email_address "ehs@basildon.gov.uk"
    scores_hygiene 0
    scores_structual 0
    scores_confidence_in_management 0
    scheme_type "FHRS"
    Geocode_Longitude 4.603730000000000e-001
    Geocode_Latitude 5.156951500000000e+001
  end
end
