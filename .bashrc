export MAVEN2_HOME=/usr/local/maven-2.2.1
export PATH=$PATH:$MAVEN2_HOME/bin:$PATH 
export NDK_PROJECT_PATH=/Users/nojo/Documents/workspace-and/DocomoIdManager

# VersionInstance
alias svnsv="ssh -i /Users/nojo/okudaT/sshkey/04-T-NDCM-GJMP.pem ec2-user@54.64.198.66"
alias gitlab="ssh -i /Users/nojo/okudaT/sshkey/04-T-NDCM-GJMP.pem ec2-user@52.192.200.141"

# ContextAwarenessServer
alias caw_poc="ssh -i /Users/nojo/okudaT/sshkey/nd0005-20160520_id_rsa ndyamaguchik@52.68.93.203"

# FitbitServer
alias fitbit="ssh -i /Users/yamaguchikuh/AWS/fitbit_instance/fitbit_key.pem ec2-user@ec2-54-238-249-210.ap-northeast-1.compute.amazonaws.com"

# ShortCut Command
alias ls='/usr/local/bin/gls --color=auto'
alias ll='ls -l'
alias excel='cat ~/workspace/tool/vim/excel_cheetsheat.md'

# Python Environment
alias note='docker exec -it -d wwworkData jupyter notebook'
alias py3='source activate py33con'
alias py2='source deactivate'

# Golang Environment
export GOPATH=~/workspace/lab/go

# Access Postgres on Docker
alias postgresql='docker run -it --rm --link postgres0:postgres postgres psql -h postgres -U postgres -v /Users/nojo/workspace/:/usr/share/locale/'
