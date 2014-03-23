require "./config/boot"
require "./config/environment"

require "clockwork"
include Clockwork

every 1.days, 'Process Importers' do
  Delayed::Job.enqueue ImporterWorker.new
end