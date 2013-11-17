class Badge < ActiveRecord::Base
  validates :name, presence: true
  validates :description, presence: true
  validates :type, presence: true

  def number_of_awards(user)
    raise NotImplementedError
  end
end
