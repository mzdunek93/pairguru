require 'rails_helper'

RSpec.describe SendMovieInfoJob, type: :job do
  let!(:movies) { create_list(:movie, 5, title: 'Godfather') }
  it "sends movie info" do
    ActiveJob::Base.queue_adapter = :test
    visit "/movies/1/send_info"
    expect(SendMovieInfoJob).to have_been_enqueued.exactly(:once).with(nil, Movie.find(1))
  end
end
