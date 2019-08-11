require 'rails_helper'

RSpec.describe ExportMoviesJob, type: :job do
  it "exports movies" do
    ActiveJob::Base.queue_adapter = :test
    file_path = "tmp/movies.csv"
    visit "/movies/export"
    expect(ExportMoviesJob).to have_been_enqueued.exactly(:once).with(nil, file_path)
  end
end
