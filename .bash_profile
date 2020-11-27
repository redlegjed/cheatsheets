
# Bash profile for Linux/Raspberry Pi

# Add to .bashrc
#if [ -f ~/.bash_profile ]; then
#    . ~/.bash_profile  
#fi


# Bash up arrow history

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'


# Git branch on prompt
# =======================
parse_git_branch(){
git branch 2>/dev/null|sed -e '/^[^*]/d' -e 's/*\(.*\)/(\1)/'
}
PS1="\w\$(parse_git_branch) $ "


# Git aliases
# ------------
alias gs="git status"
alias gc="git commit"
alias ga="git add"
alias gl="git log"

echo "Git aliases"
echo "------------"
echo "gs : git status"
echo "gc : git commit"
echo "ga : git add"
echo "gl : git log"
