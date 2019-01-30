require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:michael)
    remember(@user)
  end

  test "セッションがnilのときはcurrent_userはuserを返す" do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test "セッションが正しくないときcurrent_userはnilを返す" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end