# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
end

  test 'サインアップページへ行ける' do
    get signup_path
    assert_response :success
  end

  test 'ログインしていないときeditからリダイレクトする' do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'ログインしてないときupdateせずリダイレクトする' do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test '異なるユーザーでログインしている時editからリダイレクトする。' do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test '異なるユーザーでログインしている時updateせずリダイレクトする。' do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'ログインしていないとき、フォロー一覧を見れない' do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test 'ログインしていないとき、フォロワー一覧を見れない' do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
end
