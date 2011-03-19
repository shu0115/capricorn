class User < ActiveRecord::Base

  # 仮想属性
  attr_accessor :password
  attr_accessor :password_confirmation
  attr_accessor :edit_password
  attr_accessor :edit_password_confirmation

  # バリデーション
  validates_presence_of :login_id, :message => 'が入力されていません。'  # 存在検証
  validates_presence_of :password, :message => 'が入力されていません。'  # 存在検証
  validates_uniqueness_of :login_id, :message => 'は既に登録されています。'  # 一意検証
  validates_confirmation_of :password, :message => 'が一致しません。'  # 再入力検証

  #----------#
  # validate #
  #----------#
  # データ検証
  def validate
    errors.add_to_base( "パスワードを設定して下さい。" ) if self.hashed_password.blank?
  end

  #-------------------#
  # password=( pass ) #
  #-------------------#
  # 書き込み用メソッド
  def password=( pass )

    @password = pass

    # ソルト生成
    self.salt = create_new_salt

    # 暗号化パスワード生成
    self.hashed_password = User.encrypted_password( self.password, self.salt )

  end

  #--------------#
  # authenticate #
  #--------------#
  # ユーザ認証メソッド(ログイン)
  def authenticate

    # ユーザ検索
    current_user = User.find_by_login_id( self.login_id )

    unless current_user.blank?
      # 暗号化パスワード生成
      expected_password = User.encrypted_password( self.password, current_user.salt )

      # 暗号化パスワードとハッシュパスワードが一致しなければ
      unless expected_password == current_user.hashed_password
        # nilを返す
        return nil
      else
        # ユーザを返す
        current_user
      end
    end

  end

  #-----------------#
  # password_check? #
  #-----------------#
  # パスワードチェック
  def password_check?( check_password )

      # 暗号化パスワード生成
      expected_password = User.encrypted_password( check_password, self.salt )

      # 暗号化パスワードとハッシュパスワードが一致しなければ
      unless expected_password == self.hashed_password
        return false
      else
        return true
      end
  end

  private
  #-----------------#
  # create_new_salt #
  #-----------------#
  # ソルト生成
  def create_new_salt
    # オブジェクトIDと乱数よりソルトを生成
    self.object_id.to_s + rand.to_s
  end

  #-------------------------#
  # self.encrypted_password #
  #-------------------------#
  # 暗号化パスワード生成
  def self.encrypted_password( password, salt )
    # 暗号化パスワード生成元文字列を格納
    string_to_hash = password + "wibble" + salt # 'wibble'を付けて推測されにくくする

    # 暗号化パスワードを生成
    Digest::SHA1.hexdigest( string_to_hash )
  end

end
