#
# DONT TOUCH ;)
#

PROJECT = $(shell basename $(CURDIR))
ICONFONT = $(PROJECT)iconfont
ICONFONTPATH = public/fonts/$(PROJECT)iconfont/
ICONFONTCSS = $(ICONFONTPATH)/$(ICONFONT).css

.PHONY: build
build: package.json $(ICONFONTPATH) public/index.html public/index.css $(ICONFONTCSS) public/vendor

.PHONY: deploy
deploy: build serenacapozzi.github.io
	cp -Rf public/* serenacapozzi.github.io
	cd serenacapozzi.github.io && git add -A && git commit -m "new version" && git push origin master
	cd ..

serenacapozzi.github.io:
	git clone git@github.com:serenacapozzi/serenacapozzi.github.io.git

package.json:
	npm init
	npm install stylus --save

$(ICONFONTPATH):
	mkdir -p $@
	cp -rf tpl/iconfont/* $@

styles/index.styl:
	mkdir -p $(@D)
	cp tpl/index.styl $@

public/index.html:
	mkdir -p $(@D)
	cp tpl/index.html $@

public/index.css: ./node_modules/stylus/bin/stylus styles/index.styl
	mkdir -p $(@D)
	./node_modules/stylus/bin/stylus -o $@ styles/index.styl

$(ICONFONTCSS): .FORCE
	$(MAKE) FONTNAME=$(PROJECT) -C $(ICONFONTPATH)

public/vendor/:
	mkdir -p $@
	cp -rf tpl/vendor/* $@

node_modules ./node_modules/%:
	npm install

.FORCE:

.PHONY: clean
clean:
	-rm -Rf fonts public styles package.json node_modules serenacapozzi.github.io

.PHONY: debug
debug:
	echo $(PROJECT)
	echo $(ICONFONTPATH)
	echo $(PROJECT)
