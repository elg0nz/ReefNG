require "temporal/worker"

namespace :operators do
  desc "respond to discord tasks"
  task discord: [:environment] do
    Operators::Discord::Worker.new
  end
end
