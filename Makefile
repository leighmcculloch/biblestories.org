deploy: deploy-en-es419 deploy-fr deploy-ptBR deploy-zhHans

deploy-en-es419:
	DEPLOYMENT=0 bundle exec middleman build

deploy-fr:
	DEPLOYMENT=1 bundle exec middleman build

deploy-ptBR:
	DEPLOYMENT=2 bundle exec middleman build

deploy-zhHans:
	DEPLOYMENT=3 bundle exec middleman build

cdn: cdn-en-es419 cdn-fr cdn-ptBR cdn-zhHans

cdn-en-es419:
	$(call cdn_invalidate,108ac40627d170f7a29636cbed147f66)

cdn-fr:
	$(call cdn_invalidate,8cb4d535732e676704b61f6dcb0ac6e1)

cdn-ptBR:
	$(call cdn_invalidate,dd1490a0f957f39e5cb2e16336a19c68)

cdn-zhHans:
	$(call cdn_invalidate,46d1fe70eafcd3a2c08fab7096464d1e)

define cdn_invalidate
	curl -X DELETE "https://api.cloudflare.com/client/v4/zones/$(1)/purge_cache" \
    -H "X-Auth-Email: $(CLOUDFLARE_EMAIL)" \
    -H "X-Auth-Key: $(CLOUDFLARE_CLIENT_API_KEY)" \
    -H "Content-Type: application/json" \
    --data '{"purge_everything":true}'
endef

