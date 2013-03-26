package main

import (
  "flag"
  "fmt"
  "os"

  "github.com/libgit2/git2go"
)

var usageMessage = "usage: crawl [-repo repository-path]"

func usage() {
  fmt.Println(usageMessage)
  os.Exit(1)
}

var (
  repoPath = flag.String("repo", ".", "path of the git repository")
)

func main() {
  flag.Usage = usage
  flag.Parse()

  var repo, err = git.OpenRepository(*repoPath)
  if err != nil {
    fmt.Println(err)
    os.Exit(2)
  }

  var walk *git.RevWalk
  walk, err = repo.Walk()
  if err != nil {
    fmt.Println(err)
    os.Exit(3)
  }

  err = walk.PushHead()
  if err != nil {
    fmt.Println(err)
    os.Exit(4)
  }

  walk.Iterate(func (commit *git.Commit) bool { return walkCommit(repo, commit) })
}

func walkCommit(repo *git.Repository, commit *git.Commit) bool {
  var tree, err = commit.Tree()
  if err != nil {
    fmt.Println(err)
    return false
  }
  tree.Walk(func (dir string, entry *git.TreeEntry) int { return walkTree(repo, dir, entry) })
  return true
}

func walkTree(repo *git.Repository, dir string, entry *git.TreeEntry) int {
  if entry.Type == git.OBJ_BLOB {
    var obj, err = repo.LookupBlob(entry.Id)
    if err != nil {
      fmt.Println(err)
    } else {
      fmt.Printf("> %d %s%s\n", obj.Size(), dir, entry.Name)
    }
  }
  return 0
}
