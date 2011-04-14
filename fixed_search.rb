require 'find'

require 'text-formatting'
require 'data-dao'

def check_file_name(file_name)
  if (file_name && (file_name != "Thumbs.db")) then
    unless /^\./ =~ file_name  # ファイル名が"._"から始まるファイル(隠しファイル)は処理をしない
      return true
    else
      return false
    end
  else
    return false
  end
end

TEXT_SEARCH_DIRECTORY = "/Volumes/share/Sites/sb/entry/daily-record"  # テキストファイルを検索し始める一番上の階層

data_dao = DataDao.new()

Find.find(TEXT_SEARCH_DIRECTORY) do |path|
#  if EXTENSION_ARRAY.index(File.extname(path))  # 対象のファイル拡張子が処理対象に該当するかチェックする
  if File.file?(path) then
    array_split_path = path.split("/")  # ファイルのパスを "/" で分割する
    if check_file_name(array_split_path[9]) then # /Volumes/share/Sites/sb/entry/daily-record/._2011 みたいな Mac システムファイルを回避する
      file_path = array_split_path[7] + "/" + array_split_path[8] + "/" + array_split_path[9]
      updated_at = File.mtime(path).strftime("%Y-%m-%d %H:%M:%S")
      
      processing_flag = false  # 処理フラグ、これが true なら定型文登録処理を行う
      if database_updated_at = data_dao.get_updated_at_text_file(file_path) then
        # 同パスのデータが見つかった
        if updated_at != database_updated_at then
          # updated_at がデータベースの値と違っていれば UPDATE 処理を行う
          data_dao.update_text_file_manage(updated_at, file_path)
          processing_flag = true
        end
      else
        # 同パスのデータが見つからなかった場合は INSERT 処理を行う
        data_dao.insert_text_file_manage(updated_at, file_path)
        processing_flag = true
      end
      
      if processing_flag then
        text_formatting = TextFormatting.new()  # テキスト整形クラス
        
        # debug
        puts path
        open(path) {|file|  # ファイル読み込み
          while line = file.gets  # 1行ずつ読み込む
            line.chomp!  # 改行コードを削除
            line = text_formatting.remove_html_tags(line)
            
            # 該当文字列を取得
            if text_formatting.check_format(line) && text_formatting.check_sentence_length(line) then
              unless data_dao.select_fixed_by_text(line) then  # 同じ定型文が登録されていなければ処理を実行する
                # テキスト整形
                line = text_formatting.replace_sign(line)
                line = text_formatting.replace_tone(line)
                
                # 整形した定型文をデータベースに保存する
                data_dao.insert_fixed(line)
              end # unless
            end # if
          end #while
        } # open
      end # if
      
    end # unless
  end # if
end # find
