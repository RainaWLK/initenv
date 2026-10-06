#!/bin/bash

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# modify default shell to bash5
/opt/homebrew/bin/brew install bash

echo /opt/homebrew/bin/bash | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/bash
echo 'export PATH="$HOME/.local/bin:/opt/homebrew/bin:$PATH"' >> ~/.bash_profile
echo "restart your terminal to use bash5 as default shell"
# echo $BASH_VERSION

# install aws cli
curl -fsSL https://awscli.amazonaws.com/v2/install.sh | bash

# install apple container
curl -fsSL https://github.com/apple/container/releases/download/1.5.0/container-1.5.0-installer-signed.pkg

cat >> ~/.bash_profile <<'EOF'
docker() {
  if (( $# == 0 )); then container --help; return; fi
  local cmd=$1; shift
  case $cmd in
    ps)           container list "$@" ;;
    images)       container image list "$@" ;;
    rmi)          container image delete "$@" ;;
    pull|push|tag|save|load) container image "$cmd" "$@" ;;
    login|logout) container registry "$cmd" "$@" ;;
    *)            container "$cmd" "$@" ;;
  esac
}
export -f docker
EOF


# install kubectl & kubectx
brew install kubectl
brew install kubectx


# kube-ps1



# uv
brew install uv
uv python install 3.14 --default

# route pip / pip3 to uv pip
if ! grep -q '^pip() { uv pip' ~/.bash_profile 2>/dev/null; then
  cat >> ~/.bash_profile <<'EOF'

# uv: use pip / pip3 as uv pip
pip()  { uv pip "$@"; }
pip3() { uv pip "$@"; }
EOF
fi

# tf and tfswitch












