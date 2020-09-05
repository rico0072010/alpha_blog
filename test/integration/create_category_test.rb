require 'test_helper'

class CreateCategoryTest < ActionDispatch::IntegrationTest
  setup do
    @admin_user = User.create(username: 'jojo', email: 'jojo@gmail.com',
                              password: 'foobar', admin: true)
    sign_in_as(@admin_user)
  end

  test 'get new category form and create category' do
    get categories_path
    assert_response :success
    assert_difference 'Category.count', 1 do
      post categories_path, params: { category: { name: 'Sports' } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match 'Sports', response.body
  end

  test 'get new category form and reject invalid submission' do
    get categories_path
    assert_response :success
    assert_no_difference 'Category.count', 0 do
      post categories_path, params: { category: { name: '' } }
    end
    assert_select 'div.panel'
    assert_select 'h2.panel-title'
  end
end
