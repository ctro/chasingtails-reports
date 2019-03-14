# == Schema Information
#
# Table name: reports
#
#  id            :integer          not null, primary key
#  walk_date     :date
#  walk_time     :string(255)
#  weather       :string(255)
#  recap         :text
#  pees          :string(255)
#  poops         :string(255)
#  energy        :string(255)
#  vocalization  :string(255)
#  overall       :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  walk_duration :integer
#  client_id     :integer
#  uuid          :string(255)
#  user_id       :integer
#  deleted_at    :datetime
#  no_show       :boolean          default(FALSE)
#
class Report < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :client
  belongs_to :user, -> { with_deleted }
  has_many :report_dogs, dependent: :destroy
  has_many :dogs, through: :report_dogs
  has_many :images, dependent: :destroy

  # Always
  validates_presence_of :client, :dogs, :walk_date, :walk_time, :walk_duration

  validates_presence_of :weather, :recap, :pees, :poops, :energy,
                        :vocalization, :overall,
                        unless: :no_show?

  # Validates this format: YYYY-M(M)-D(D)
  #   a little more lax than HTML5.
  DATE_REGEX = /\A\d{4}-\d{1,2}-\d{1,2}\z/.freeze

  # Validates this format: HH:MM
  #   Military time.  Sorry Android.
  TIME_REGEX = /\A\d{2}:\d{2}\z/.freeze

  # Validates an integer, kind of unnecessary because can't even set a string.
  DURATION_REGEX = /\A\d+\z/.freeze

  validates :walk_date, format: { with: DATE_REGEX,
                                  message: 'Date should look like YYYY-MM-DD' }

  # Most browsers show a time selector, this message is aimed at older browsers.
  validates :walk_time,
            format:
            {
              with: TIME_REGEX,
              message: 'Time should look like HH:MM -- yeah, military time.'
            }

  validates :walk_duration,
            format: { with: DURATION_REGEX,
                      message: 'Duration should be a number like 60 or 90' }

  validate :presence_of_images, unless: :no_show?

  before_create :set_uuid
  after_create :deliver_new_report_email

  accepts_nested_attributes_for :images, reject_if: ->(a) { a['asset'].blank? }

  def to_param
    uuid
  end

  def dog_names
    dogs.map(&:name).join(', ')
  end

  def formatted_walk_time
    walk_time.to_time.strftime('%I:%M %P')
  end

  private

  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  def deliver_new_report_email
    ReportMailer.new_report_email(self).deliver_now
  end

  def presence_of_images
    if images.none? { |i| !i.asset.nil? }
      errors[:base] << 'You have to attach at least one image.'
    end
  end
end
