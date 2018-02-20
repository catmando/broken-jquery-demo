# config/initializers/hyperloop.rb
# If you are not using ActionCable, see http://ruby-hyperloop.io/docs/models/configuring-transport/
Hyperloop.configuration do |config|
  config.transport = :action_cable
  #config.import 'opal-jquery'
  config.import 'reactrb/auto-import'
  config.import 'opal_hot_reloader'
end
