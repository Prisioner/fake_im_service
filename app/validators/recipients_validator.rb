class RecipientsValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add :im, :blank if record.recipients.any? { |r| r[:im].blank? }
    record.errors.add :uid, :blank if record.recipients.any? { |r| r[:uid].blank? }
  end
end
