class Establishment < ActiveRecord::Base
  
  has_many :visits, :inverse_of => :establishment
end
