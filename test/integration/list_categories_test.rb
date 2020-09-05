require 'test_helper'

class ListCategoriesTest < ActionDispatch::IntegrationTest
  def setup
    @category = Category.create(name: 'Sports')
    @other_category = Category.create(name: 'Travel')
  end

  test 'should get categories index page with created categories' do
    get categories_path
    assert_select 'a[href=?]', category_path(@category), text: @category.name
    assert_select 'a[href=?]', category_path(@other_category), text: @other_category.name
  end
end
