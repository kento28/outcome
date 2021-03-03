## アプリケーション概要
Outcome

<br>

(width: 400px)

<img width="398" alt="スクリーンショット 2021-03-02" src="https://user-images.githubusercontent.com/70310592/109604469-ed1e5200-7b66-11eb-808c-b9fc3ae8d938.png">

<br>

width: 1024px

<img width="1021" alt="スクリーンショット 2021-03-02" src="https://user-images.githubusercontent.com/70310592/109604422-d677fb00-7b66-11eb-8ede-1442dcfd0130.png">

<br>

非ログイン状態でも記事の閲覧は可能です。
ゲストログインをしていただくことで記事の投稿やいいね等各アクションが可能になります。

最小画面サイズ => 320pxまで対応しています。

<br>

## リンク
- URL : http://13.230.3.252

<br>

## ジャンル
日々のアウトプットを記録する日記SNS

<br>

## 特徴
- デフォルトが非公開でログアプリとして使いやすい
- インプット情報を検索してネタ探し、共有ができる

<p>気軽にアウトプットをするための機能を揃えています。</p>


<br>

## 開発背景
<p> 上京して営業職を辞めてから人と直接話す機会が減り、自分自身のアウトプットをすることがほぼなくなりました。</p>
<p>それからインプットした情報があまり定着せず、何か日常的な出来事もすぐ忘れてしまうことが多くなったのです。</p>

<p>そこで、アウトプットした情報を投稿し共有でき、閲覧制限も可能な日記寄りのSNSアプリを作りました。</p>
<p>また、学習意欲が高い人のアウトプット情報源なども共有でき、コミュニケーションも取れることで、アプリのユーザー同士の自己研鑽にも活用できます。</p>

このアプリを通して、アウトプットをしやすい環境を作り人々の成長や喜びに貢献したいです。

<br>

## 使用技術
- Ruby 2.6.5 / Rails 6.0.3.4
- MySQL
- JavaScript
- jQuery
- Git / GitHub
- AWS(EC2,S3)
- Nginx
- Capistrano

<br>

## 機能一覧
◆ユーザー系
- ユーザーページ
  - ユーザーインフォメーション
  - アクション数
  - 週間アナリティクス
  - 投稿一覧

◆投稿
- 公開選択
- 画像投稿
- ハッシュタグ登録
- マークダウン

◆一覧表示
- ページネーション
- 画像サムネイル表示

◆検索
- カテゴリ
- ハッシュタグ
- ユーザー
- タイトル

◆その他機能
- いいね
- コメント
- タイムライン
- スマホ用コマンド

## ER図
![Output App ER図 (1)](https://user-images.githubusercontent.com/70310592/109806959-a7e24900-7c68-11eb-925b-eed37f9aeac6.png)

## テーブル設計

### users テーブル

| Column       | Type    | Options                   |
| ------------ | ------- | ------------------------- |
| username     | string  | null: false, unique: true |
| email        | string  | null: false               |
| password     | string  | null: false               |

### Association

- has_one  :profile
- has_many :items
- has_many :comments
- has_many :commented_items, through: :comments, source: :item
- has_many :likes
- has_many :liked_items, through: :likes, source: :item
- has_many :relationships
- has_many :followings, through: :relationships, source: :follow
- has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
- has_many :followers, through: :reverse_of_relationships, source: :user
- has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id'
- has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id'

### profiles テーブル

| Column       | Type       | Options                        |
| ------------ | ---------- | ------------------------------ |
| lastname     | string     |                                |
| firstname    | string     |                                |
| website      | string     |                                |
| intro        | text       |                                |
| user         | references | null: false, foreign_key: true |

### Association

- belongs_to       :user
- has_one_attached :image

### relationships テーブル

| Column       | Type       | Options                        |
| ------------ | ---------- | ------------------------------ |
| user         | references | null: false, foreign_key: true |
| follow       | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- belongs_to :follow, class_name: 'User'

### items テーブル

| Column       | Type       | Options                        |
| ------------ | ---------- | ------------------------------ |
| title        | string     | null: false                    |
| url          | string     |                                |
| tagbody      | string     |                                |
| body         | text       | null: false                    |
| status       | integer    | null: false, default: 0        |
| category_id  | integer    | null: false                    |
| user         | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- has_many :likes
- has_many :liked_users, through: :likes, source: :user
- has_many :comments
- has_many :commented_users, through: :comments, source: :user
- has_many :item_tags
- has_many :tags, through: :item_tags
- belongs_to_active_hash :category
- has_one_attached :image
- has_many :notifications, dependent: :destroy

### tags テーブル

| Column       | Type       | Options                        |
| ------------ | ---------- | ------------------------------ |
| name         | string     || null: false, unique: true     |

### Association

- has_many :item_tags
- has_many :items, through: :item_tags

### item_tags テーブル

| Column | Type       | Options           |
| ------ | ---------- | ----------------- |
| item   | references | foreign_key: true |
| tag    | references | foreign_key: true |

### Association

- belongs_to :item
- belongs_to :tag

### likes テーブル

| Column | Type       | Options           |
| ------ | ---------- | ----------------- |
| user   | references | foreign_key: true |
| item   | references | foreign_key: true |

### Association

- belongs_to :user
- belongs_to :item

### comments テーブル

| Column  | Type       | Options                        |
| ------- | ---------- | ------------------------------ |
| message | text       | null: false                    |
| user    | references | null: false, foreign_key: true |
| item    | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- belongs_to :item
- has_many :notifications

### notification テーブル

| Column     | Type       | Options                        |
| ---------- | ---------- | ------------------------------ |
| visitor_id | integer    | null: false                    |
| visited_id | integer    | null: false                    |
| item_id    | integer    |                                |
| comment_id | integer    |                                |
| action     | string     | null: false, default: ''       |
| checked    | boolean    | null: false, default: false    |

### Association

- belongs_to :item, optional: true
- belongs_to :comment, optional: true
- belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', optional: true
- belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true