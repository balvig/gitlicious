Factory.define :report do |f|
  f.sha {Factory.next(:sha)}
end


Factory.sequence :sha do |n|
  n
end
