# encoding: UTF-8

require 'json'
require_relative './carto_json_serializer'

class Carto::State < ActiveRecord::Base
  belongs_to :visualization, class_name: Carto::Visualization
  belongs_to :user, class_name: Carto::User

  default_scope order('created_at DESC')

  STATE_CHANNELS = ['public', 'private'].freeze

  serialize :json, ::Carto::CartoJsonSymbolizerSerializer

  validates :json, carto_json_symbolizer: true
  validates :channel, inclusion: { in: STATE_CHANNELS }
  validates :visualization, :user, presence: true

  before_save :ensure_json

  private

  def ensure_json
    self.json ||= Hash.new
  end

  def accessible_by?(user)
    public? || user_id == user.id
  end

  def public?
    channel == 'public'
  end
end
