module Hyperloop
  def self.mount_all
    query = '[data-hyperloop-mount]'
    #Element['[data-hyperloop-mount]'].each do |mount_point|
    `$('[data-hyperloop-mount]')`.each do |mount_point|
      component_name = `mount_point.attr(query)`
      component = nil
      begin
        component = Object.const_get(component_name)
      rescue
        message = "Could not find Component class named #{component_name}"
        `console.error(message)`
        next
      end
      params = Hash[*Hash.new(`mount_point.data`).collect do |name, value|
        [name.underscore, value] unless name == 'hyperloop-mount'
      end.compact.flatten(1)]
      React.render(React.create_element(component, params), mount_point)
    end
  end
  %x{
     window.hyperloop_mount_all = function() {
       #{Hyperloop.mount_all}
      }
    }
end
