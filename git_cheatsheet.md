Git cheatsheet
====================

Good tutorial: https://www.atlassian.com/git/tutorials/what-is-git
(Have to sit down and read it carefully though, not a quick reference)

Getting a Git repository from GitHub
-------------------------------------

    git clone https://github.com/redlegjed/cheatsheets.git



Branches
------------

* Viewing


    git branch      <-- List all local branches, shows asterisk at the currently selected branch
    git branch -a   <-- List all branches including remote branches

* Creating a branch


    git branch <new branch name>    <-- Make the branch (Working directory is NOT pointing at it yet)
    git checkout <new branch name>  <-- Point the working directory to the new branch

* Add files to branch


    git add <filename>                <-- Add file to the branch selected by 'git checkout'
    git add --all                     <-- Add all files to branch
    git commit -m "put message here"  <--  Commit files to local branch selected by 'git checkout'


* Rebasing branch to remote/master repository


    git checkout <branch name>   <-- Select the branch to be updated
    git pull --rebase origin     <-- Update branch from remote repository 


Updating from a specific branch in the remote repository:
    
    git pull --rebase origin develop   <-- Update from the branch 'develop' in the 'origin' repository
    
Updating from a branch in the remote repository that does not exist in the local repository

    git checkout --track origin/branch_name  <-- Creates a new branch "branch_name" in local repo that tracks "branch_name" from remote repo

Note: In Git, rebasing means putting all the changes of the current branch after all the updated changes from the remote repository.

* Merging branches back into master branch


    git checkout master               <-- Select the master branch
    git merge new_branch              <-- Merge changes from new_branch in master
    git branch -d new_branch          <-- Delete new branch if required
    
* Rebasing from a local branch    
    git checkout old_branch        <-- Select the branch to be rebased
    git rebase master              <-- rebase old_branch relative to master branch
    
    git rebase --abort            <-- If it all goes wrong, back up using this


* Conflicts
    git checkout --ours PATH/FILE       <-- Select version of FILE from this branch
    git checkout --theirs PATH/FILE     <-- Select version of FILE from branch that has been merged in
    

* Pushing changes back to origin repository


    git push <remote> <branch>.
    git push -u origin devel
    
    
* Deleting branches both remote and local


    git push origin --delete <branch_name>    <-- Delete remote branch
    git branch -d <branch_name>               <-- Delete local branch
    git branch -D <branch_name>               <-- Delete local branch even if not merged

Cleanup checked out repositories, i.e. remove the deleted branch from any other copies of the repository that you have.

    git fetch --all --prune
    
    
* Showing differences between the same file in different branches

    git diff branch1:file branch2:file
    
* Checking out a file from a different branch into the current branch

	git checkout different_branch -- path_to_/filename.ext

    
* Branch prefixes used by bitbucket
    - bugfix
    - feature
    - hotfix
    - release
    
See https://confluence.atlassian.com/bitbucketserver0414/using-branches-in-bitbucket-server-895367626.html?utm_campaign=in-app-help&utm_medium=in-app-help&utm_source=stash

* Tracking branches : branches that automatically track a remote branch


    git checkout --track origin/a_branch



Viewing changes
-------------------

    git status       <-- Show which files are staged, unstaged or untracked.
    git status -s    <-- Short form, less verbose output


Committing
--------------
Have to add files first

    git add myfile.txt
    git commit -m "message here"

Shortcut to avoiding having to do the add all the time

    git commit -a -m "message here"
    
Show differences between what has already been staged and what has been modified. Do this before doing a 'git add'.

    git diff
    
To see what changes you have just staged (after a 'git add') use:
    
    git diff --staged
    
    
Tagging
-----------

List all tags

    git tag
    
Search for tags with a pattern

    git tag -l <tag text pattern>
    git tag -l "v1.85*"
    
Create tag

    git tag -a <tag text> -m <message tag>
    git tag -a "Rel_00.02.05" -m "A very important release"
    git tag -a "Rel_00.02.05"                    <-- Opens editor for message
    
    
Remove tag

    git tag -d <tag text>
    
    
Show message for a tag

    git show <tag text>
    git show "Rel_00.02.05"
    
Tags don't get pushed to the remote repository automatically. They have to be pushed:

Push tag to remote repository:
    
    git push origin <tag text>
    git push origin "Rel_00.02.05"
        
        
Push all tags to remote repository

    git push origin --tags

Tags don't seem to be 'pulled' either to get the tags:

    git pull --tags
    
This may work as well, when pulling a branch from a remote repository

    git pull --tags origin branch_name

Show differences between tags

    git diff tag1 tag2
    
    
Differences
--------------

View differences between the same file for two different tags

    git diff tag1 tag2 -- file.txt
    
The same can be done for branches

    git diff branch1 branch2 -- file.txt
    
Differences between two different files

    git diff <revision_1>:<file_1> <revision_2>:<file_2>
    
Where a revision can be a branch,tag, SHA hex number etc


View which files have changes between 2 branches

    git diff --name-status branch1..branch2 
    
    Can also send to a text file
    
    git diff --name-status branch1..branch2 > logfile.txt
    
    Colourfull version
    
    git diff --stat --color branch1..branch2


Removing files
-----------------
Remove file from staging area and the working directory, i.e. delete the file

    git rm filename

Remove file from staging area but keep it in the working directory

    git rm --cached README
    
Remove directory

    git rm -r directory_name


Renaming files
---------------
Use the mv command

    git mv myfile.txt yourfile.txt



Display log of commits
-----------------------

    git log

Show one line per commit

    git log --pretty=oneline

Use format for customised output
This shows the abbreviated SHA-1 code, author, when committed and the message

    git log --pretty=format:"%h - %an, %ar : %s"


Ascii graph

    git log --pretty=format:"%h %s" --graph


Show what changed in a particular commit

    git show --name-status <commit>.


see https://git-scm.com/book/en/v2/Git-Basics-Viewing-the-Commit-History
for more

Displaying user info
======================

Show user name and email

    git config user.name
    git config user.email
    

This stuff lives in the file

    ~/.gitconfig

    
    
Updating from another local repository
========================================

If you have 2 local repositories then you can update one from the other
by adding one as a remote branch to the other.

e.g. Two repositories:  /folder1/repo1 and /folder2/repo2

Add repo2 as a remote branch of repo1

    cd /folder1/repo1
    git remote add repo2_label /folder2/repo2
    
Fetch repo2

    git fetch repo2_label
    
Merge changes in master branch (substitute other branch names)

    git merge repo2_label/master

    
Also see how to make a git bundle for transferring between repositories that are not
directly connected:
http://schacon.github.io/git/git-bundle.html
https://git-scm.com/blog/2010/03/10/bundles.html

Alternative using bundles

Bundle up a repository

    git bundle create <name of bundle file> <branch name>
    git bundle create repo1.bundle master

Go to other version of repository (repo2)

Verify the bundle (assume it's outside the current directory at ../)

    git bundle verify ../repo1.bundle

Read commits from bundle into current repo as a new branch

    git fetch ../repo1.bundle master:temporary_branch

Merge commits from bundle into master branch

    git merge temporary_branch


Stashing
============

Temporarily store your working directory

    git stash
    
Re-apply stashed changes
    
    git stash apply
    
Get list of stashes

    git stash list
    
    
Removing files that were committed but are now ignored
=========================================================

For single files

    git rm --cached <file>
    
To apply .gitignore to everything

    git rm -r --cached . 
    git add .
    
    
    
Sub modules
==================

Reference [https://git-scm.com/book/en/v2/Git-Tools-Submodules]

Adding another repository as a folder in the current repo

    git submodule add https://github.com/chaconinc/DbConnector
    
This adds a .gitmodules file into the repo

Have to commit both the .gitmodules file and the submodule folder.


Cloning a repo with sub modules, add --recurse-submodules options

    git clone --recurse-submodules https://github.com/chaconinc/MainProject
    

Updating a submodule

Go into sub module directory and use git fetch followed by git merge

    git fetch
    git merge origin/master


To see changes from merge

    git diff --submodule 
    
or
    git status
    
Update submodule directory 

    git submodule update --remote <submodule directory name>
    
(updates from origin/master branch by default)

    
Set submodule branch to update from

    git config -f .gitmodules submodule.<submodule folder>.branch <submodule branch name>
    
This just adds a line to the .gitmodules file with the branch name.


Making changes to submodule

* Need to checkout a branch
* Specify whether to merge or rebase updates from submodule origin

Checkout a branch by going into the submodule directory and checking out a branch

    cd submodule_dir 
    git checkout master
    
Update from submodule origin using merge
    git submodule update --remote --merge


Update from submodule origin using rebase
    git submodule update --remote --rebase
    
    
Making git check if submodules have been pushed before a commit

    git push --recurse-submodules=check
    
Make this the default action by setting the configuration

    git config push.recurseSubmodules check

    
Committing changes to submodule

Just go into submodule directory and do the normal add/commit cycle. BUT a local branch must have been checked out!!
    

Troubleshooting
==========================

* Unlink of file 'spec.xlsx' failed. Should I try again? (y/n) 
    - This probably means there is an Excel process with the file open somewhere in the background. Solution is to find the Excel and close it. Don't commit until Excel has released the file.
