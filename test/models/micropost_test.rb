require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    # buildの使い方 なるほど
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "正しさ" do
    assert @micropost.valid?
  end

  test "ユーザIDが存在するか" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "コンテンツが存在するか" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "コンテンツが140文字以上か" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "最新のものから順に" do
    assert_equal microposts(:most_recent), Micropost.first
  end 
end
