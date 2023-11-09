require 'google/apis/youtube_v3'

class YoutubeController < ApplicationController
  def new; end

  def show
    youtube_api_service = Google::Apis::YoutubeV3::YouTubeService.new
    youtube_api_service.key = Rails.application.credentials.YOUTUBE_API_KEY
  
    video_id = extract_video_id(params[:url])
    part = 'snippet,contentDetails,statistics'
  
    begin
      response = youtube_api_service.list_videos(part, id: video_id)
      video = response.items.first
  
      if video
        channel_id = video.snippet.channel_id
        channel_response = youtube_api_service.list_channels('statistics', id: channel_id)
        channel = channel_response.items.first
        
        @video_info = {
          title: video.snippet.title,
          description: video.snippet.description,
          view_count: video.statistics.view_count
        }
        if channel
          @video_info[:channel_subscribers] = channel.statistics.subscriber_count
        else
          flash[:error] = 'Channel not found.'
          redirect_to new_youtube_path and return
        end
      else
      flash[:error] = 'Video not found.'
      redirect_to new_youtube_path and return
    end
    rescue Google::Apis::Error => e
      flash[:error] = e.message
      redirect_to new_youtube_path
    end
  end

  private

  def extract_video_id(url)
    uri = URI.parse(url)
    if uri.host == 'www.youtube.com' && uri.path == '/watch'
      CGI.parse(uri.query)['v'].first
    elsif uri.host == 'youtu.be'
      uri.path[1..]
    else
      nil
    end
  end
end
