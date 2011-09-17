Factory.define :commit do |f|
  f.sha {Factory.next(:sha)}
  f.association :project
end


Factory.sequence :sha do |n|
  n
end
