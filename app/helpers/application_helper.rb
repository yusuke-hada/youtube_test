module ApplicationHelper
      # YouTubeの動画リンクからビデオIDを抽出するメソッド
  def extract_youtube_video_id(link)
    # もしリンクが提供されていない場合、ビデオIDは存在しないので nil を返す
    return nil if link.nil?
    
    # URLを解析してビデオIDを取得する
    uri = URI(link)  # リンクのURLをURIオブジェクトに変換
    query = URI.decode_www_form(uri.query)  # URLのクエリパラメータをデコードして取得
    query_hash = Hash[query]  # クエリパラメータをハッシュに変換
    query_hash["v"]  # ハッシュからキー"v"に対応する値、ビデオIDを返す
  end
end
