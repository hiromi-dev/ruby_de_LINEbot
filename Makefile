up:
	docker-compose up -d
stop:
	docker-compose stop
build:
	docker-compose build
down:
	docker-compose down
ps:
	docker-compose ps
#Railsコンソール
c:
	docker-compose run web bundle exec rails c
#rubocop自動化テスト
ruba:
	docker-compose run web bundle exec rubocop -a
#rubocopテスト確認
rub:
	docker-compose run web bundle exec rubocop
#dbコンテナ データベースによって記述は都度変更
sql:
	docker exec -it ror2_db_1 mysql -u root -p
