## アプリケーション名
Outcome



非ログイン状態でも記事の閲覧は可能です。
ゲストログインをしていただくことで記事の投稿やいいね等各アクションが可能になります。

## リンク
- URL : http://13.230.3.252

## 概要
日々のアウトプットを記録して共有できるログ型SNS

## 特徴
- デフォルトが非公開でログアプリとして使いやすい
- インプット情報を検索してネタ探し＆共有ができる



## 開発背景
- 自己成長に繋がるログ＆コミュニケーションツールが必要だったため
- インプットの情報源を共有したかったため


## 使用技術
- Ruby 2.6.5 / Rails 6.0.3.4
- MySQL2
- JavaScript
- jQuery
- Git / GitHub
- Amazon S3

## 機能一覧（開発中の機能含む）
◆ユーザー機能
- deviseを使用
- ユーザーページ
  - 投稿一覧表示
  - 投稿アナリティクス表示 ※開発中
  - ステータス表示(投稿/フォロー/いいね/コメント 各総数)
  - プロフィール編集（本人のみ）
  - フォロワー数表示（本人のみ）

◆投稿機能
- マークダウン記法
- ハッシュタグ機能
- 投稿プレビュー機能 ※開発中
- カウントアップタイマー機能 ※開発中

◆検索機能
- カテゴリ別検索
- ハッシュタグ検索
- ユーザー名検索
- 投稿タイトル検索

◆トレンド表示機能 ※開発中
- 最新×人気の投稿をピックアップ

◆サジェスト機能 ※開発中
- 類似投稿のサジェスト

◆フォロー機能

◆いいね機能

◆コメント機能

## ER図

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
- has_many :likes
- has_many :relationships
- has_many :followings, through: :relationships, source: :follow
- has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
- has_many :followers, through: :reverse_of_relationships, source: :user

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
- has_many   :likes
- has_many   :comments
- has_many   :item_tags
- has_many   :tags, through: :item_tags
- belongs_to_active_hash :category

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