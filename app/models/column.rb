# == Schema Information
#
# Table name: columns
#
#  id         :integer          not null, primary key
#  name       :string
#  english    :string
#  icon       :string
#  cover      :string
#  summary    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'csv'
class Column < ActiveRecord::Base
  validates_presence_of :name, :english, :icon
  validates_uniqueness_of :name, :english
  has_many :videos, :dependent => :destroy
  scope :latest, ->{ order(updated_at: :desc) }
  scope :recent, ->{ order(created_at: :desc) }
  scope :hexie, ->{ where("english != 'Fucking'")}
  scope :seqing, ->{ where("english = 'Fucking'")}
  scope :shunxu, ->{ order(id: :asc) }
  scope :daoxu, ->{ order(id: :desc) }

  def self.picture_url(file)
    if file.present?
      return Cattle.cache_to_yun(file)
    else
      return nil
    end
  end

  def self.to_csv_data(videos)
    CSV.generate do |csv|
      num = 0
      csv << ["\xEF\xBB\xBF序号",'视频标题','优酷编号','视频头图'] #解决乱码
      videos.each do |item|
        num += 1
        csv << [num,item.title,item.youku_id,item.video_cover]
      end
    end
  end

  def self.file_or_url(file,url)
    return Cattle.cache_to_yun(file) if file.present?
    return url if file.nil?
  end
end
