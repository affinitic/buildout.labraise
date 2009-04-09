#!/usr/bin/make
#
# Makefile for La Braise
#
BOOTSTRAP_PYTHON=python
EASY_INSTALL=easy_install

all: run

.PHONY: bootstrap
bootstrap:
#	$(EASY_INSTALL) virtualenv
	virtualenv --no-site-packages .
	if ! test -f bin/python2.4;then cd bin; ln -s python python2.4; cd ..; fi
	./bin/python2.4 bootstrap.py

.PHONY: buildout
buildout: bootstrap
	if test -f bin/buildout;then bin/buildout -vvv;fi

.PHONY: run
run:
	if ! test -f bin/instance;then make buildout;fi
	bin/instance fg

.PHONY: cleanall
cleanall:
	rm -fr bin/instance bin/buildout bin/zopepy bin/repozo develop-eggs downloads eggs parts var .installed.cfg

.PHONY: db
db: ID tags

.PHONY: ID
ID:
	mkid -m ~/.id-lang.map . $(EGG_PATH)

.PHONY: tags
tags:
	ctags -R --languages=-JavaScript -f tags.new \
		. $(EGG_PATH) && mv tags.new tags
