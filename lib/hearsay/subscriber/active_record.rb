module Hearsay
  module Subscriber
    module ActiveRecord
      extend ActiveSupport::Concern
      class_methods do

        def subscribe_to(klass, *args)
          args.each do |arg|
            key = klass == :all ? /hearsay\.active_record\.\w+\.#{arg}/ : "hearsay.active_record.#{klass}.#{arg}"
            Hearsay.subscribe! key do |event|
              klass_name, method_name = event.name.split('.').last(2)
              if name.constantize.respond_to? :listen
                send(:listen, event)
              else
                puts "#{name} is subscribed to Hearsay events but does not implement a .listen method"
              end
            end
          end
        end
      end
    end
  end
end
