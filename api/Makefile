bexec = bundle exec

reset:
	$(bexec) rake db:drop db:create db:migrate db:seed

test:
	RAILS_ENV=test $(bexec) rake test

lint:
	$(bexec) rake standard:fix

console:
	$(bexec) rails c

serve:
	$(bexec) rails s

migrate:
	$(bexec) rake db:migrate

.PHONY: test lint serve migrate