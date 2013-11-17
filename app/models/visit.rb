class Visit < ActiveRecord::Base
  belongs_to :establishment
  belongs_to :user, :inverse_of => :visits
end
