module Hearsay
  module Railties
    module ActiveRecordExtension
      extend ActiveSupport::Concern

      included do
        after_save do
          Hearsay::Publisher.push('model', {
            class: self.class.name,
            method: 'save',
            attributes: attributes.symbolize_keys,
            changes: respond_to?(:saved_changes) ? saved_changes : changes
          })
        end

        after_update do
          Hearsay::Publisher.push('model', {
            class: self.class.name,
            method: 'update',
            attributes: attributes.symbolize_keys,
            changes: respond_to?(:saved_changes) ? saved_changes : changes
          })
        end

        after_create do
          Hearsay::Publisher.push('model', {
            class: self.class.name,
            method: 'create',
            attributes: attributes.symbolize_keys
          })
        end

        after_destroy do
          Hearsay::Publisher.push('model', {
            class: self.class.name,
            method: 'destroy',
            attributes: attributes.symbolize_keys
          })
        end

        after_rollback do
          Hearsay::Publisher.push('model', {
            class: self.class.name,
            method: 'rollback',
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
