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
    t="ps/$1";
    echo "[ps-save] branch: $b, remote: $r, tag: $t.";
    git tag -f "$t" $(git stash create) && git push -f "$r" tag "$t";
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
    t="ps/$1";
    echo "[ps-apply] branch: $b, remote: $r, tag: $t.";
    git fetch -p "$r" refs/tags/ps/*:refs/tags/ps/* && git stash apply --index "$t";
  };
  f
'
git_alias ps-drop '!
  f()
  {
    test -n "$1" || { echo "Public stash name is not defined."; return; };
    b=$(git rev-parse --abbrev-ref HEAD);
    r=$(git config --get branch.${b}.remote);
    t="ps/$1";
    echo "[ps-drop] branch: $b, remote: $r, tag: $t.";
    git push "$r" ":refs/tags/$t" && git tag -d "$t";
  };
  f
'
git_alias ps-pop '!
  f()
  {
    test -n "$1" || { echo "Public stash name is not defined."; return; };
    b=$(git rev-parse --abbrev-ref HEAD);
    r=$(git config --get branch.${b}.remote);
    t="ps/$1";
    echo "[ps-pop] branch: $b, remote: $r, tag: $t.";
    git ps-apply "$1" && git ps-drop "$1";
  };
  f
'
git_alias ps-diff '!
  f()
  {
    test -n "$1" || { echo "Public stash name is not defined."; return; };
    t="ps/$1";
    git diff $t^ $t;
  };
  f
'
git_alias ps-list '!
  f()
  {
    b=$(git rev-parse --abbrev-ref HEAD);
    r=$(git config --get branch.${b}.remote);
    git fetch -p "$r" refs/tags/ps/*:refs/tags/ps/* >/dev/null 2>&1 && git tag -l "ps/*$1*" | sed "s=ps/==";
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
