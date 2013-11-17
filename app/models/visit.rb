class Visit < ActiveRecord::Base
  belongs_to :establishments
  belongs_to :users
end
