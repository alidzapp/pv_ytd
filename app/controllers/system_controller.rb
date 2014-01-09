class SystemController < ApplicationController
  def index
    @latest_convertions = Convertion.where(:encoding_status => 1).order("created_at DESC").limit(10)
  end

  def enqueue
    if !params[:url] && params[:url].length < 3
      redirect_to :action => 'index'
    end

    convertion_model = Convertion.new
    convertion_model.url = params[:url]
    convertion_model.save

    t = ConvertJob.new(convertion_model.id)
    t.delay.process
    redirect_to :action => 'progress', :token => convertion_model.token
  end

  def progress
    @convertion_model = Convertion.where(:token => params[:token]).first
    if @convertion_model.encoding_status == 1
      redirect_to :action => 'finished', :token => @convertion_model.token
    end
  end

  def finished
    @convertion_model = Convertion.where(:token => params[:token]).first
  end
end
