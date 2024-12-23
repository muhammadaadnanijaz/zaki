export PATH="$PATH:/Users/macbookair/Library/Python/3.9/bin"
export PATH=$PATH:/Users/macbookair/Downloads/flutter/bin
export JAVA_HOME=$(/usr/libexec/java_home -v 22.0.1)
export PATH=$JAVA_HOME/bin:$PATH
Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/macbookair/StudioProjects/zaki/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/macbookair/StudioProjects/zaki/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/macbookair/StudioProjects/zaki/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/macbookair/StudioProjects/zaki/google-cloud-sdk/completion.zsh.inc'; fi
