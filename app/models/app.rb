class App

  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :app_id, type: String
  field :app_secret, type: String
  field :redirect_uri, type: String
  field :homepage, type: String
  field :owner, type: String
  field :email, type: String
  
  validates_presence_of :name,:app_id,:app_secret,:redirect_uri,:homepage,:email,:owner,  message: "不能为空"
  validates_uniqueness_of :name, :redirect_uri,:app_id,  message: "信息重复"

end
