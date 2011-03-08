Factory.define :tag do |f|
  f.name {Factory.next(:tag_name)}
  f.association :project
  f.flog 5000
  f.loc 20000
end


Factory.sequence :tag_name do |n|
  "buildsuccess/master/#{n}"
end
