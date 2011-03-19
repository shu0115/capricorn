class Task < ActiveRecord::Base

  # カテゴリ取得
#  named_scope :categorys,
#    :conditions => [ "category IS NOT NULL AND category != ''" ],
#    :select => "DISTINCT category",
#    :order => "category ASC"

  # 検索
  named_scope :categorys, lambda { |user_id|
    { 
      :conditions => [ "category IS NOT NULL AND category != '' AND user_id = #{user_id.to_i}" ],
      :select => "DISTINCT category",
      :order => "category ASC"
    }
  }

  #--------#
  # search #
  #--------#
  def self.search( args )
    args[:search] = Hash.new if args[:search].blank?
    args[:search][:page] = args[:params][:page] unless args[:params][:page].blank?
    args[:search][:page] = 1 if args[:search][:page].blank? or args[:search][:page] == 0
    args[:search][:category] = args[:params][:category] unless args[:params][:category].blank?
    args[:search][:status] = args[:params][:status] unless args[:params][:status].blank?

    condition_text = "user_id = #{args[:user_id].to_i}"
    condition_hash = Hash.new
    order = "created_at DESC, updated_at DESC"

    # カテゴリ
    unless args[:search][:category].blank?
      condition_text += " AND category = :category"
      condition_hash[:category] = args[:search][:category]
    end

    # ステータス
    if args[:search][:status] == "完了"
      condition_text += " AND status = '完了'"
    elsif args[:search][:status] == "未完了"
      condition_text += " AND ( status = '' OR status IS NULL )"
    end

    # 先頭の「AND」削除
#    condition_text = condition_text.sub( "AND", "" )

    # 検索
    tasks = Task.paginate(
      :page => args[:search][:page],
      :per_page => $per_page,
      :conditions => [ condition_text, condition_hash ],
      :order => order
    )

    return tasks, args[:search]
  end

end
