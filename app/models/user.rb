require 'digest'
class User
  include Mongoid::Document
  include Mongoid::Timestamps
  field :login, type: String
  field :password, type: String
  field :realname, type: String
  field :avatar_url, type: String
  validates_presence_of :login,:realname,:password,:password_confirmation, message: "不能为空"
  validates_uniqueness_of :login , message: "用户已经存在"
  validates_confirmation_of :password , message: "密码不匹配"
  validates_length_of :login, minimum: 3, message: '长度不能小于3'
  validates_length_of :password, minimum: 6, message: '长度不能小于6'
  
end
