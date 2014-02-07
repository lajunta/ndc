class Student
  include Mongoid::Document
  include Mongoid::Timestamps
  paginates_per 20
  field :realname, type: String
  field :sex, type: String
  field :birthday, type: String
  field :default_group, type: String
  field :other_groups, type: String
  field :address, type: String
  field :hometel, type: String
  field :mobile, type: String
  field :father_name, type: String
  field :mother_name, type: String
  field :father_workplace, type: String
  field :mother_workplace, type: String
  field :father_profession, type: String
  field :mother_profession, type: String
  field :father_tel, type: String
  field :mother_tel, type: String
  field :intro, type: String
  field :logo, type: Hash


  index({realname: 1})
  index({sex: 1})
  index({birthday: 1})
end
