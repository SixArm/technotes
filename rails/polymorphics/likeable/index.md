# Likeable

<https://medium.com/@jamesreed3050/setting-up-polymorphic-likes-in-rails-7d8be2e01c12>

We want a user to be able to like anything that we say is likeable, such as a person, place, thing, etc.

## Generate

Run:

```sh
rails generate model like user:references likeable:references{polymorphic}
```

The output is a migration file and looks lke this:

```ruby
t.references :user, null: false, foreign_key: true
t.references :likeable, polymorphic: true, null: false
```

The first line associates with a specific user.

The second line creates two table columns: 

* `likeable_type` records the target model, such as `Person`, `Place`, `Thing`. 

* `likeable_id` records the target model id, such as Person id 1.

## Constrain

We want to constrain each user to be able to have at most one like for each likeable item.

Add this like to the migration file:

```ruby
t.index [:user_id, :likeable_type, :likeable_id ], unique: true
```

Result:

```ruby
t.references :user, null: false, foreign_key: true
t.references :likeable, polymorphic: true, null: false
t.index [:user_id, :likeable_type, :likeable_id ], unique: true
```

## Migrate

Run the migration:

```sh
rails db:migrate
```

## Schema

The output is a schema change that looks like this:

```ruby
create_table "likes", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id", null: false
    t.string "likeable_type", null: false
    t.integer "likeable_id", null: false
    t.index ["user_id"], name: "index_likes_on_user_id"
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable"
    t.index ["user_id", "likeable_type", "likeable_id"], 
      name: "index_likes_on_user_id_and_likeable_type_and_likeable_id", 
      unique: true
  end
```

## Add validation

The generated file `models/like.rb` looks like:

```ruby
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true
end
```

We want to add a scoped uniqueness validation. This is because we want error feedback, and also want a layer of validation that can skip unnecessary database queries.

Add this validation:

```ruby
validates :user_id, uniqueness: { scope: %i[likeable_id likeable_type] }
```

Result:

```ruby
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true
  validates :user_id, uniqueness: { scope: %i[likeable_id likeable_type] }
end
```

## Adjust the user

Suppose the model file `models/user.rb` looks like:

```ruby
class User < ApplicationRecord
end
```

Add this association:

```ruby
has_many :likes
```

Result:

```ruby
class User < ApplicationRecord
  has_many :likes, dependent: :destroy
end
```

## Make a model likeable

Suppose you have a model file `models/thing.rb` like this:

```ruby
class Thing < ApplicationRecord
end
```

Add these associations:

```ruby
has_many :likeables, as: :likeable, dependent: :destroy
has_many :likes, :through => :likeables
```

Result:

```ruby
class Thing < ApplicationRecord
  has_many :likeables, as: :likeable, dependent: :destroy
  has_many :likes, :through => :likeables
end
```

## Refactor to a concern

For larger projects, we prefer to refactor code into a Rails concern, because we feel this makes it clearer to read and modify.

Create a file:

```ruby
# /app/models/concerns/likeable.rb
module Likeable
  extend ActiveSupport::Concern

  included do
    has_many :likeables, as: :likeable, dependent: :destroy
    has_many :likes, :through => :likeables
```
