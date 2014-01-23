class Teacher
  include Mongoid::Document
  field :realname, type: String
  field :sex, type: String
  field :birthday, type: String
  field :tel, type: String
  field :mobile, type: String
  field :email, type: String
  field :default_group, type: String
  field :logo, type: String
end
