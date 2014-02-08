# -*- encoding : utf-8 -*-
class Teacher
  include Mongoid::Document
  include Mongoid::Timestamps
  field :realname, type: String
  field :sex, type: String
  field :birthday, type: String
  field :tel, type: String
  field :mobile, type: String
  field :email, type: String
  field :default_group, type: String
  field :logo, type: Hash

  index({realname: 1})
  index({sex: 1})
  index({birthday: 1})
end
