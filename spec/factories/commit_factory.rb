Factory.define :commit do |f|
  f.sha {Factory.next(:sha)}
  f.association :project
  f.flog 5000
  f.loc 20000
end


Factory.sequence :sha do |n|
  n
end
