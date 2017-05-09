class Hearsay::Railties::ActionControllerExtension
  extend ActiveSupport::Concern
  # maybe put something here to exclude certain actions from publishing?
end

ActiveSupport.on_load(:active_record) do
  include Hearsay::Railties::ActionControllerExtension
end
