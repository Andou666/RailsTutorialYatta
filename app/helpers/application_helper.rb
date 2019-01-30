module ApplicationHelper
  # 関数説明：ページごとのTitleを返します。
  # パラメータ： 
  #   page_title　Titleタグで利用
  def full_title(page_title = '')
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end    
end
