class Hub
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :creator, type: String
  field :end_on, type: Date
  field :users, type: Array
  field :groups, type: Array
  has_many :submissions , dependent: :restrict
  def users_list=(arg)
    self.users = arg.split(',').map { |v| v.strip }
  end

  def users_list
    self.users.join(",") if self.users
  end

  def groups_list=(arg)
    self.groups = arg.split(',').map { |v| v.strip }
  end

  def groups_list
    self.groups.join(",") if self.groups
  end

end
