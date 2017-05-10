module Hearsay
  module Railties
    module ActiveRecordExtension
      extend ActiveSupport::Concern

      included do
        after_save do
          ActiveSupport::Notifications.instrument("hearsay.active_record.#{self.class.name}.save", {
            attributes: attributes.symbolize_keys,
            changes: saved_changes
          })
        end

        after_update do
          ActiveSupport::Notifications.instrument("hearsay.active_record.#{self.class.name}.update", {
            attributes: attributes.symbolize_keys,
            changes: saved_changes
          })
        end

        after_create do
          ActiveSupport::Notifications.instrument("hearsay.active_record.#{self.class.name}.create", {
            attributes: attributes.symbolize_keys
          })
        end

        after_destroy do
          ActiveSupport::Notifications.instrument("hearsay.active_record.#{self.class.name}.destroy", {
            attributes: attributes.symbolize_keys
          })
        end
      end
    end
  end
end

ActiveSupport.on_load(:active_record) do
  include Hearsay::Railties::ActiveRecordExtension
end
