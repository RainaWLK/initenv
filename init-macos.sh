#!/bin/bash

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# modify default shell to bash5
/opt/homebrew/bin/brew install bash

echo /opt/homebrew/bin/bash | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/bash
echo "export PATH=/opt/homebrew/bin:$PATH" >> ~/.bash_profile
echo "restart your terminal to use bash5 as default shell"
# echo $BASH_VERSION

# install aws cli
curl -fsSL https://awscli.amazonaws.com/v2/install.sh | bash
ln -s /Users/${USER}/.local/share/aws-cli/aws /opt/homebrew/bin/aws 


# install apple container
curl -fsSL https://github.com/apple/container/releases/download/1.5.0/container-1.5.0-installer-signed.pkg

# after apple container is installed.
container system start