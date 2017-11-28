#!/bin/sh
#
# Configures your local repo with useful aliases/etc
#

echo "Configuring repository..."
echo


git_alias()
{
  git config alias.$1 "$(echo "$2" | tr -d "\n")"
}


echo "Configuring public stash..."
git_alias ps-save '!
  f()
  {
    test -n "$1" || { echo "Public stash name is not defined."; return; };
    b=$(git rev-parse --abbrev-ref HEAD);
    r=$(git config --get branch.${b}.remote);
    echo "[ps-save] branch: $b, remote: $r, ref: $1.";
    hash=$(git stash create);
    git push -f "$r" "$hash:refs/ps/$1";
  };
  f
'
git_alias ps-backup '!
  f()
  {
    b=$(git rev-parse --abbrev-ref HEAD);
    git ps-save "${USER}_${b}_wip";
  };
  f
'
git_alias ps-apply '!
  f()
  {
    test -n "$1" || { echo "Public stash name is not defined."; return; };
    b=$(git rev-parse --abbrev-ref HEAD);
    r=$(git config --get branch.${b}.remote);
    echo "[ps-apply] branch: $b, remote: $r, ref: $1.";
    git fetch -p "$r" refs/ps/*:refs/ps/* && git stash apply --index "refs/ps/$1";
  };
  f
'
git_alias ps-drop '!
  f()
  {
    test -n "$1" || { echo "Public stash name is not defined."; return; };
    b=$(git rev-parse --abbrev-ref HEAD);
    r=$(git config --get branch.${b}.remote);
    echo "[ps-drop] branch: $b, remote: $r, ref: $1.";
    git push "$r" ":refs/ps/$1";
  };
  f
'
git_alias ps-pop '!
  f()
  {
    test -n "$1" || { echo "Public stash name is not defined."; return; };
    b=$(git rev-parse --abbrev-ref HEAD);
    r=$(git config --get branch.${b}.remote);
    echo "[ps-pop] branch: $b, remote: $r, ref: $1.";
    git ps-apply "$1" && git ps-drop "$1";
  };
  f
'
git_alias ps-diff '!
  f()
  {
    test -n "$1" || { echo "Public stash name is not defined."; return; };
    git diff "refs/ps/$1^" "refs/ps/$1";
  };
  f
'
git_alias ps-list '!
  f()
  {
    b=$(git rev-parse --abbrev-ref HEAD);
    r=$(git config --get branch.${b}.remote);
    git fetch -fp "$r" refs/ps/*:refs/ps/* >/dev/null 2>&1 && git show-ref | grep "refs/ps/" | grep "$1";
  };
  f
'
git_alias ps-help '!
  echo "Public stash usage examples:";
  echo "  > git ps-save igoro_wip";
  echo "  > git ps-backup";
  echo "  > git ps-apply igoro_wip";
  echo "  > git ps-drop igoro_wip";
  echo "  > git ps-pop igoro_wip";
  echo "  > git ps-diff igoro_wip";
  echo "  > git ps-list";
  echo "  > git ps-list wip";
  echo "  > git ps-help";
'
git ps-help
echo "Public stash configuration complete."



echo
echo "Repository configuration complete."
