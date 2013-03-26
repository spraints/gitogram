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

  var odb *git.Odb
  odb, err = repo.Odb()
  if err != nil {
    fmt.Println(err)
    os.Exit(5)
  }
  walk.Iterate(func (commit *git.Commit) bool { return walkCommit(odb, commit) })
}

func walkCommit(odb *git.Odb, commit *git.Commit) bool {
  var tree, err = commit.Tree()
  if err != nil {
    fmt.Println(err)
    return false
  }
  tree.Walk(func (dir string, entry *git.TreeEntry) int { return walkTree(odb, dir, entry) })
  return true
}

func walkTree(odb *git.Odb, dir string, entry *git.TreeEntry) int {
  if entry.Type == git.OBJ_BLOB {
    var obj, err = odb.Read(entry.Id)
    if err != nil {
      fmt.Println(err)
    } else {
      fmt.Printf("> %d %s%s\n", obj.Len(), dir, entry.Name)
    }
  }
  return 0
}
