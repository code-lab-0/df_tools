#!/bin/bash -x

# mac OS Xにhomebrewでperl環境構築
# http://tesiri.hateblo.jp/entry/2015/02/24/002523
# keywords: plenv,cpanm

brew update
#brew upgrade
brew install perl-build
brew install cpanminus
cpanm Set::IntSpan
cpanm Set::Scalar
