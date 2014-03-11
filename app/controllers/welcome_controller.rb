# -*- encoding : utf-8 -*-
class WelcomeController < ApplicationController
  def index
    @cr_schedule=CrSchedule.where(used: true).first
    render layout: nil
  end
  def home
  end
end
