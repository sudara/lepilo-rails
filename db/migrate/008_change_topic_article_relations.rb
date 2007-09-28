class ChangeTopicArticleRelations < ActiveRecord::Migration
  def self.up
    add_column :topics, :article_id, :integer
    remove_column :articles, :topic_id
  end

  def self.down
    remove_column :topics, :article_id
    add_column :articles, :topic_id, :integer
  end
end
