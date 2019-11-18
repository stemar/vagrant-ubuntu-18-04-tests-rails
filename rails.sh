echo '==> Installing rbenv'

apt-get -qq install autoconf bison build-essential \
    libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm5 libgdbm-dev
if [ ! -d /home/vagrant/.rbenv ]; then
    git clone -q https://github.com/rbenv/rbenv.git /home/vagrant/.rbenv
fi
if ! grep -q 'RBENV_ROOT=' /home/vagrant/.bashrc; then
   echo '
# Make rbenv load automatically
export RBENV_ROOT="${HOME}/.rbenv"
export PATH="${RBENV_ROOT}/bin:${PATH}"
eval "$(rbenv init -)"
' | tee -a /home/vagrant/.bashrc > /dev/null
fi
export RBENV_ROOT="/home/vagrant/.rbenv"
if ! grep -q "$RBENV_ROOT" <<< "$PATH"; then
    export PATH="${RBENV_ROOT}/bin:${PATH}"
fi
eval "$(rbenv init -)"
if [ ! -d /home/vagrant/.rbenv/plugins/ruby-build ]; then
    git clone -q https://github.com/rbenv/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build
fi
chown -R vagrant:vagrant /home/vagrant/.rbenv

echo '==> Installing Ruby'

LATEST_RUBY_VERSION=$(rbenv install -l | grep -v - | tail -1)
rbenv install -s $LATEST_RUBY_VERSION
rbenv global $LATEST_RUBY_VERSION
echo "gem: --no-document" | tee /home/vagrant/.gemrc > /dev/null
chown -R vagrant:vagrant /home/vagrant/.gemrc

echo '==> Installing Bundler'

gem install bundler -N -q --no-force

echo '==> Installing Rails'

gem install rails -N -q --no-force
bundle install
rbenv rehash

echo '==> Installing npm, node.js & Grunt'

apt-get -qq install npm
npm list grunt-cli || npm install -g grunt-cli

echo '==> Versions:'

echo $(rbenv -v)
echo $(ruby -v)
echo gem $(gem -v)
echo $(bundler -v)
echo $(rails -v)
echo node.js $(nodejs -v)
echo npm $(npm -v)
