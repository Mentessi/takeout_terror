# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :visit, :class => 'Visits' do
    user_id 1
    establishment_id 1
  end
end
