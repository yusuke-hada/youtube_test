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
        @video_info = {
          title: video.snippet.title,
          description: video.snippet.description,
          view_count: video.statistics.view_count
        }
      else
        flash[:error] = 'Video not found.'
        redirect_to new_youtube_path and return
      end
    rescue Google::Apis::Error => e
      flash[:error] = e.message
      redirect_to new_youtube_path
    end
  end

  def get_video_info
    youtube_api_service = Google::Apis::YoutubeV3::YouTubeService.new
    youtube_api_service.key = Rails.application.credentials.YOUTUBE_API_KEY

    begin
      video_id = extract_video_id(params[:url]) # URLからvideo_idを抽出するメソッド
      part = 'snippet,contentDetails,statistics' # 取得したい情報の種類
      options = { id: video_id, part: part }
      response = youtube_api_service.list_videos(part, options)
      video = response.items.first

      if video
        render json: {
          title: video.snippet.title,
          description: video.snippet.description,
          view_count: video.statistics.view_count
        }
      else
        render json: { error: 'Video not found.' }, status: :not_found
      end
    rescue Google::Apis::Error => e
      render json: { error: e.message }, status: :bad_request
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
