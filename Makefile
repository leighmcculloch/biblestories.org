deploy: deploy-en-es419 deploy-fr deploy-ptBR deploy-zhHans

deploy-en-es419:
	DEPLOYMENT=0 bundle exec middleman build

deploy-fr:
	DEPLOYMENT=1 bundle exec middleman build

deploy-ptBR:
	DEPLOYMENT=2 bundle exec middleman build

deploy-zhHans:
	DEPLOYMENT=3 bundle exec middleman build
