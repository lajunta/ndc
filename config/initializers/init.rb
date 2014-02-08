# -*- encoding : utf-8 -*-
unless User.where(:login=>"root").first
  user=User.new(login: 'root',realname: 'root',
                password: 'root',password_confirmation: 'root')
  user.save!
end
