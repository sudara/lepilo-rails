require File.dirname(__FILE__) + '/../test_helper'
require 'block_links_controller'

# Re-raise errors caught by the controller.
class BlockLinksController; def rescue_action(e) raise e end; end

class BlockLinksControllerTest < Test::Unit::TestCase
  fixtures :block_links

  def setup
    @controller = BlockLinksController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:block_links)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:block_link)
    assert assigns(:block_link).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:block_link)
  end

  def test_create
    num_block_links = BlockLink.count

    post :create, :block_link => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_block_links + 1, BlockLink.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:block_link)
    assert assigns(:block_link).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil BlockLink.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      BlockLink.find(1)
    }
  end
end
