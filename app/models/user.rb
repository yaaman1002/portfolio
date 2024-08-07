class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :liked_posts, dependent: :destroy

  has_one_attached :profile_image

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password=SecureRandom.urlsafe_base64
    end
  end

  def get_profile_image(width,height)
    unless profile_image.attached?
      file_path=Rails.root.join('app/assets/images/default-image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  def liked_posted_by?(post_id)
    liked_post.where(post_id: post_id).exists?
  end

  def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
    elsif method == 'forward'
      User.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      User.where('name LIKE ?', '%' + content)
    else
      User.where('name LIKE ?', '%' + content + '%')
    end
  end

  def active_for_authentication?
    super && (is_active == true)
  end
end
