# == Schema Information
#
# Table name: movies
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  released_at :datetime
#  avatar      :string
#  genre_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Movie < ApplicationRecord
  belongs_to :genre

  def as_json(options={})
    if options.key?(:only) or options.key?(:methods) or options.key?(:include) or options.key?(:except)
      super(options)
    else
      super(only: [:id, :title])
    end
  end
end
