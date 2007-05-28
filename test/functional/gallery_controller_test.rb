require File.dirname(__FILE__) + '/../test_helper'
require 'collection_controller'

# Re-raise errors caught by the controller.
class CollectionController; def rescue_action(e) raise e end; end

class CollectionControllerTest < Test::Unit::TestCase
  def setup
    @controller = CollectionController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
