STACK=llrt
DOMAINNAME = llrt.dabase.com
ACMCERTIFICATEARN = arn:aws:acm:eu-west-2:407461997746:certificate/9083a66b-72b6-448d-9bce-6ee2e2e52e36
VERSION=0.1

deploy:
	sam build
	sam deploy --no-progressbar --resolve-s3 \
	 --stack-name $(STACK) --parameter-overrides DomainName=$(DOMAINNAME) ACMCertificateArn=$(ACMCERTIFICATEARN) Version=$(VERSION) \
	 --no-confirm-changeset --no-fail-on-empty-changeset --capabilities CAPABILITY_IAM

build-HelloWorldFunction:
	npm install esbuild
	npx esbuild hello-world/app.mjs --platform=node --target=es2020 --format=esm --bundle --minify --external:@aws-sdk --external:uuid --outdir=out
	cp -r out/*js $(ARTIFACTS_DIR)
	curl -s https://api.github.com/repos/awslabs/llrt/releases/latest | grep "llrt-lambda-x64.zip" | cut -d : -f 2,3 | tail -1 | xargs curl -o llrt.zip -L
	unzip llrt.zip
	mv bootstrap $(ARTIFACTS_DIR)
