class ZeroRatingBadge < Badge

  def number_of_awards(user)
    user.visits.where(:fs_rating_value => 0).count > 0 ? 1 : 0
  end

end