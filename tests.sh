echo '==> Installing Composer (globally)'

if [ ! -f /usr/local/bin/composer ]; then
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --quiet
fi

echo '==> Installing Codeception (globally)'

if [ ! -f /usr/local/bin/codecept ]; then
    curl -LsS https://codeception.com/codecept.phar -o /usr/local/bin/codecept
    chmod a+x /usr/local/bin/codecept
fi

echo '==> Installing Java JRE'

apt-get -qq install default-jdk
apt-get -qq install --fix-broken

echo '==> Installing Google Chrome'

if ! grep -qxF 'deb http://dl.google.com/linux/chrome/deb/ stable main' /etc/apt/sources.list; then
    echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' | tee -a /etc/apt/sources.list > /dev/null
    wget -qO- --no-hsts "https://dl-ssl.google.com/linux/linux_signing_key.pub" | apt-key add -
    apt-get -qq update
    apt-get -qq install google-chrome-stable
fi

echo '==> Installing Google XVFB'

apt-get -qq install xvfb
apt-get -qq install --fix-broken

echo '==> Installing chromedriver'

CHROMEDRIVER_VERSION=2.38
if [ ! -f /usr/local/bin/chromedriver ]; then
    curl -LsS https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip -o /usr/local/bin/chromedriver.zip
    unzip -qq /usr/local/bin/chromedriver.zip -d /usr/local/bin
    chown vagrant:vagrant /usr/local/bin/chromedriver
    rm /usr/local/bin/chromedriver.zip
fi

echo '==> Installing geckodriver'

GECKODRIVER_VERSION=v0.20.1
if [ ! -f /usr/local/bin/geckodriver ]; then
    curl -LsS https://github.com/mozilla/geckodriver/releases/download/$GECKODRIVER_VERSION/geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz -o /usr/local/bin/geckodriver.tar.gz
    tar -xzf /usr/local/bin/geckodriver.tar.gz -C /usr/local/bin
    chown vagrant:vagrant /usr/local/bin/geckodriver
    rm /usr/local/bin/geckodriver.tar.gz
fi

echo '==> Installing Selenium'

SELENIUM_VERSION=3.12
if [ ! -f /usr/local/bin/selenium-server-standalone.jar ]; then
    curl -LsS https://selenium-release.storage.googleapis.com/$SELENIUM_VERSION/selenium-server-standalone-$SELENIUM_VERSION.0.jar -o /usr/local/bin/selenium-server-standalone.jar
    chown vagrant:vagrant /usr/local/bin/selenium-server-standalone.jar
fi
