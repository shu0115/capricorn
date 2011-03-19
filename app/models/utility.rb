# 汎用メソッド用クラス
class Utility

  #----------------------#
  # self.replace_message #
  #----------------------#
  # メッセージ置換
  def self.replace_message( args )
    message = args[:message]
    message = message.gsub( "Member was successfully created.", "メンバーの作成が正常に完了しました。" )
    message = message.gsub( "Member was successfully updated.", "メンバーの更新が正常に完了しました。" )
    message = message.gsub( "User was successfully created.", "ユーザ登録が正常に完了しました。" )

    return message
  end

end
