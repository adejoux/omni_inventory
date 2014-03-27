require "./config/boot"
require "./config/environment"

require "clockwork"
include Clockwork

every 5.minutes, 'Process Importers' do
  ImporterWorker.perform
end
