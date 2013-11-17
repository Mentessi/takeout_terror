# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :visit do
    user
    establishment
    fs_rating_value 1
  end

  trait :value_rating_0 do
    fs_rating_value 0
  end

  trait :value_rating_1 do
    fs_rating_value 1
  end

  trait :value_rating_2 do
    fs_rating_value 2
  end

  trait :value_rating_3 do
    fs_rating_value 3
  end

  trait :value_rating_4 do
    fs_rating_value 4
  end

  trait :value_rating_5 do
    fs_rating_value 5
  end

end
