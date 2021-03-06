require 'rails_helper'

describe 'ユーザー管理機能', type: :system do
  let(:admin) { FactoryBot.create(:user, name: '管理者', email: 'admin@example.com', admin: true) }
  let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') }
  let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') }
  
  before do
    visit login_path
    fill_in 'メールアドレス', with: login_user.email
    fill_in 'パスワード', with: login_user.password
    click_button 'ログインする'
  end

  describe '一覧表示機能' do
    context '管理者がログインしているとき' do
      let(:login_user) { admin }

      it 'ユーザー一覧ボタンが表示される' do
        expect(page).to have_content 'ユーザー一覧'
      end
    end

    context '管理者以外がログインしているとき' do
      let(:login_user) { user_a }

      it 'ユーザー一覧が表示されない' do
        expect(page).not_to have_content 'ユーザー一覧'
      end
    end

    context 'ユーザー一覧ボタンを押下したとき' do
      let(:login_user) { admin }

      before do
        FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com')
        FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com')
        visit admin_users_path
      end

      it 'ユーザー一覧が表示される' do
        expect(page).to have_content 'ユーザーA'
        expect(page).to have_content 'ユーザーB'
      end
    end
  end

  describe '詳細表示機能' do
    context 'ユーザーAをクリックしたとき' do
      let(:login_user) { admin }

      before do
        visit admin_user_path(user_a)
      end

      it 'ユーザーAの情報が表示される' do
        expect(page).to have_content 'ユーザーA'
      end

      it '削除ボタンが表示される' do
        expect(page).to have_content '削除'
      end

      it '表示ボタンが表示される' do
        expect(page).to have_content '編集'
      end
    end
  end

  describe '新規ユーザー登録' do
    context '新規登録ボタンを押下したとき' do
      let(:login_user) { admin }

      before do
        visit new_admin_user_path
      end

      it '新規ユーザー作成画面が表示される' do
        expect(page).to have_content 'ユーザー登録'
      end
    end
  end
end

