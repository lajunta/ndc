# -*- encoding : utf-8 -*-
#encoding: utf-8
require 'digest/sha2'
class User
  include Mongoid::Document
  include Mongoid::Timestamps

  before_save :encrypt

  def encrypt
    self.password = Digest::SHA2.hexdigest(password)
  end

  field :login, type: String
  field :password, type: String
  field :realname, type: String
  field :type,     type: String
  field :config,   type: Hash ,default: {}
  field :logo, type: Hash 
  field :default_group,type: String, default: "全体"
  field :groups,type: Array
  validates_presence_of :login,:realname,:password,:password_confirmation, message: "不能为空"
  validates_uniqueness_of :login , message: "用户已经存在"
  validates_uniqueness_of :realname, message: "姓名已经存在"
  validates_confirmation_of :password , message: "密码不匹配"
  validates_length_of :login, minimum: 2, message: '长度不能小于2'
  validates_length_of :password, minimum: 4, message: '长度不能小于4'

  index({login: 1})
  index({realname: 1})
  index({type: 1})
  index({created_at: 1})
end
