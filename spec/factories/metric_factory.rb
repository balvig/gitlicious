Rails.application.config.default_metrics.each do |name,attributes|
  Factory.define :"#{name}_metric", :class => :metric do |f|
    attributes.each do |attribute,value|
      f.send(attribute,value)
    end
  end
end