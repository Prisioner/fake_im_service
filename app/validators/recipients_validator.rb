class RecipientsValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add :base, :im_blank if record.recipients.any? { |r| r[:im].blank? }
    record.errors.add :base, :uid_blank if record.recipients.any? { |r| r[:uid].blank? }
  end
end
