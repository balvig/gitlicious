FactoryGirl.define do
  factory :metric do
  end

  Metric::DEFAULTS.each do |name,attributes|
    factory :"#{name}_metric", :class => :metric do
      attributes.each do |attribute,value|
        send(attribute,value)
      end
    end
  end
end
