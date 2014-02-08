# -*- encoding : utf-8 -*-
#encoding: utf-8
class TempmediasController < ApplicationController
  layout "nobody"


  def index  
  end

  def show  
    @tempmedia=Tempmedia.where(:login=>session[:login]).first
    if @tempmedia
      @medias=@tempmedia.medias 
      @unshown_medias=@medias.select{|media| media['shown']!=true}
      @medias.each do |media|
        media[:shown]=true
      end
      @tempmedia.medias=@medias
      @tempmedia.save
    end
    respond_to do |form|
      form.html 
      form.json {render :json=> @unshown_medias}
    end
  end

  def upload 
    if params[:tempmedias]
      medias=[]
      params[:tempmedias].each do |temp|
        if temp.content_type.include?("image")
          width,height=640,480
          width=params[:width].to_i unless params[:width].blank?
          height=params[:height].to_i unless params[:height].blank?
          fpath=temp.tempfile.path
          hsh={:width=>width,:height=>height}
          hsh={:percent=>params[:percent]} unless params[:percent].blank?
          Zbox::Qm.resize(fpath,hsh)
          medias<<uploadtogrid(temp)
        end
        if temp.content_type.include?("flash") or temp.content_type.include?("video")
          medias<<uploadtogrid(temp)
        end
      end
      if medias.empty?
        flash[:error]="请选择图片文件或者视频文件"
        redirect_to :back and return
      end
      @temp=Tempmedia.where(:login=>session[:login]).first
      if @temp
        @temp.medias=@temp.medias+medias
      else
        @temp=Tempmedia.new(:login=>session[:login],:medias=>medias)
      end
      @temp.save ?  @status=1 : @status=0
    end

  end

  def remove 
    grid.delete(BSON::ObjectId.from_string(params[:grid_id]))
    tempmedia=Tempmedia.where(:login=>session[:login]).first
    if tempmedia
      medias=tempmedia.medias
      medias.each do |media|
        medias.delete(media) if media['grid_id'].to_s==params[:grid_id]
      end
      tempmedia.medias=medias
      tempmedia.save
    end
    redirect_to show_tempmedia_path
  end

end
