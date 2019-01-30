require 'test_helper'
class UserTest < ActiveSupport::TestCase
  # 初期値
  def setup
    @user = User.new(name: "Example", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
    #@user = User.first
  end

  test "あかんな" do
    assert @user.valid?
  end

  test "名前があかんな" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "メールがあかんな" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "名前が長すぎやで" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "メールが長すぎやで" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "そのメールアドレスはあかんな" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "メールが重複しとるで" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "メールは小文字やねん" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  test "パスワードがからやねん" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "パスワードは短すぎやで" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "ダイジェストがnilのとき authenticated? は false" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "関連するマイクロポストの削除" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
  
  test "フォローと解除" do
    michael = users(:michael)
    archer  = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end

  test "フィードの整合性" do
    michael = users(:michael)
    archer  = users(:archer)
    lana    = users(:lana)
    # フォローしているユーザーの投稿を確認
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # 自分自身の投稿を確認
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    # フォローしていないユーザーの投稿を確認
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end  
end
