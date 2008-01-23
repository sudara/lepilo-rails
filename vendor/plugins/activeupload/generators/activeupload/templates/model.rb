class Attachment < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true

  def dirname
    padded_id = sprintf("%6.6d", id)
    dirnames = padded_id.match("(...)(...)")
    dirname = "public/attachments/#{dirnames[1]}/#{dirnames[2]}"
  end

  def path
    "#{dirname}/#{filename}"
  end

  def to_label
    filename
  end
end
