require 'rails_helper'

describe User, type: :model do
  describe 'インスタンスの状態' do
    context '有効な場合' do
      it '名前、パスワード、確認パスワードがあれば有効な状態であること' do
        user = build(:user)
        expect(user).to be_valid
      end

      it '名前が20文字以下であれば有効な状態であること' do
        user = build(:user, name: 'a' * 20)
        expect(user).to be_valid
      end

      it 'パスワードが72文字以下であれば有効な状態であること' do
        user = build(:user, password: 'a' * 72, password_confirmation: 'a' * 72)
        expect(user).to be_valid
      end
    end

    context '無効な場合' do
      it '名前がなければ無効な状態であること' do
        user = build(:user, name: nil)
        expect(user).to be_invalid
        expect(user.errors[:name][0]).to eq I18n.t('errors.messages.empty')
      end

      it '名前が21文字以上の場合、無効な状態であること' do
        user = build(:user, name: 'a' * 21)
        expect(user).to be_invalid
        expect(user.errors[:name][0]).to eq I18n.t('errors.messages.too_long', count: 20)
      end

      it 'パスワードがなければ無効な状態であること' do
        user = build(:user, password: nil)
        expect(user).to be_invalid
        expect(user.errors[:password][0]).to eq I18n.t('errors.messages.empty')
      end

      it 'パスワードが73文字以上の場合、無効な状態であること' do
        user = build(:user, password: 'a' * 73)
        expect(user).to be_invalid
        expect(user.errors[:password][0]).to eq I18n.t('errors.messages.too_long', count: 72)
      end
    end
  end

  describe 'ユーザーの更新' do
    it 'パスワード未設定でも更新できること' do
      user = create(:user)
      expect(user.update(name: 'dummy')).to be_truthy
    end
  end

  describe 'ユーザーの取得操作' do
    describe '絞り込み検索' do
      before { 10.times { |i| create(:user, id: i, name: "User #{i}") } }

      context 'idでの絞り込み' do
        it 'idを指定した場合、合致するユーザー情報が取得できること' do
          user = User.search_by_id(9)
          expect(user.name.to_s).to eq 'User 9'
        end

        it '全てのユーザー情報が取得できること' do
          users = User.search_all
          expect(users.size).to eq 10
        end
      end

      context 'ユーザー名での絞り込み' do
        it '指定したユーザー名に完全一致する情報が取得できること' do
          user = User.search_by_name('User 1').first
          expect(user.name.to_s).to eq 'User 1'
        end
      end
    end

    describe 'ソート順' do
      before do
        10.times { |i| User.create(name: "User #{i}", password: "password#{i}", password_confirmation: "password#{i}", created_at: "2018/1/1 0:0:#{i}") }
      end

      context '作成時刻順に取得したい場合' do
        it 'created_atの昇順で取得できること' do
          user = User.order_by(sort: :created_at).first
          expect(user.created_at.to_s).to eq '2018/01/01 00:00:00'
        end

        context 'created_atが同一の場合' do
          it 'idの降順で取得できること' do
            User.all.each { |u| u.update(created_at: '2018/1/1 01:01:01') }
            user = User.order_by(sort: :created_at).first
            expect(user.name).to eq 'User 9'
          end
        end
      end

      context 'ユーザー名順に取得したい場合' do
        it 'nameの照準で取得できること' do
          user = User.order_by(sort: :name).first
          expect(user.name).to eq 'User 0'
        end

        context 'nameが同一の場合' do
          it 'idの降順で取得できること' do
            User.update_all(name: 'User X')
            user = User.order_by(sort: :name).first
            expect(user.created_at.to_s).to eq '2018/01/01 00:00:09'
          end
        end
      end

      context 'created_at、nameカラム以外ででソート順を指定した場合' do
        it '不正なカラム名を指定した場合、デフォルトでnameの昇順で取得されること' do
          user = User.order_by(sort: :password_digest).first
          expect(user.created_at.to_s).to eq '2018/01/01 00:00:00'
        end

        it 'nilを指定した場合、、デフォルトでnameの昇順で取得されること' do
          user = User.order_by(sort: nil).first
          expect(user.created_at.to_s).to eq '2018/01/01 00:00:00'
        end
      end
    end

    describe 'ページングの仕組み' do
      before { 20.times { |i| create(:user, id: i, name: "User #{format('%02d', i)}") } }

      context 'ページ番号を指定しない場合' do
        it '1~10件目のデータが取得できること' do
          users = User.search_all
          expect(users.size).to eq 10
          users.each.with_index { |user, i| expect(user.name).to eq "User #{format('%02d', i)}" }
        end
      end

      context 'ページ番号を指定した場合' do
        it '2を指定すると11~20件目のデータが取得できること' do
          users = User.search_all(page: 2)
          expect(users.size).to eq 10
          users.each.with_index { |user, i| expect(user.name).to eq "User #{format('%02d', i + 10)}" }
        end
      end

      context '不正なページ番号を指定した場合' do
        it '文字列のページ番号を指定した場合、数値に変換されてデータが返却されること' do
          users = User.search_all(page: '2')
          expect(users.size).to eq 10
          users.each.with_index { |user, i| expect(user.name).to eq "User #{format('%02d', i + 10)}" }
        end

        it '数値に変換できない値を指定した場合、1ページ目のデータが返却されること' do
          users = User.search_all(page: 'a')
          expect(users.size).to eq 10
          users.each.with_index { |user, i| expect(user.name).to eq "User #{format('%02d', i)}" }
        end

        it '負数を指定した場合、1ページ目のデータが返却されること' do
          users = User.search_all(page: -1)
          expect(users.size).to eq 10
          users.each.with_index { |user, i| expect(user.name).to eq "User #{format('%02d', i)}" }
        end
      end
    end
  end

  describe 'ユーザーが作成したタスクの関係性' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user, name: 'user2') }

    it 'ユーザー削除時に自身に関連づくタスクのみが全て削除されること' do
      2.times { |i| create(:task, title: "#{user1.name} task #{i}", user_id: user1.id) }
      4.times { |i| create(:task, title: "#{user2.name} task #{i}", user_id: user2.id) }

      expect(Task.where(user_id: user1.id).count).to eq 2
      expect(Task.where(user_id: user2.id).count).to eq 4

      user1.destroy
      expect(Task.where(user_id: user1.id).count).to eq 0
      expect(Task.where(user_id: user2.id).count).to eq 4
    end
  end
end
