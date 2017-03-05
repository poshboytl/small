Dir.glob(Rails.root.join('app/components/*')).each do |component| require component end

module TaoOnRails
  module ActionView

    module Helpers
      def render_componment component
        render partial: component.template_path, locals: { component: component, block: component.block }
      end

      Component.descendants.each do |klass|
        instance = klass.new
        module_eval %Q{
          def #{instance.component_name} options = {}, &block
            component = #{klass.name}.new options, &block
            content_tag component.tag_name, component.attributes do
              render_componment component
            end
          end
        }
      end

    end


  end
end

ActiveSupport.on_load :action_view do
  include TaoOnRails::ActionView::Helpers
end
