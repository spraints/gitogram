#include <stdio.h>
#include <git2.h>

static void
check_error(int error_code, const char* action)
{
  if (!error_code)
    return;

  const git_error *error = giterr_last();
  printf("Error %d %s - %s\n", error_code, action, (error && error->message) ? error->message : "???");
  exit(1);
}

int
each_entry(const char *root, const git_tree_entry *entry, void *payload)
{
  int error;
  git_odb *odb = payload;
  git_odb_object *object;

  if(GIT_OBJ_BLOB == git_tree_entry_type(entry))
  {
    error = git_odb_read(&object, odb, git_tree_entry_id(entry));
    check_error(error, "lookup blob");

    printf("> %zd %s%s\n", git_odb_object_size(object), root, git_tree_entry_name(entry));

    git_odb_object_free(object);
  }

  return 0;
}

int
main(int argc, char **argv)
{
  int error;
  const char *repo_path = argc == 2 ? argv[1] : ".";
  git_repository *repo;
  git_revwalk *walk;
  git_oid commit_oid;
  git_commit *commit;
  git_tree *tree;
  git_odb *odb;

  error = git_repository_open(&repo, repo_path);
  check_error(error, "open repository");

  error = git_revwalk_new(&walk, repo);
  check_error(error, "new commit walker");

  error = git_revwalk_push_head(walk);
  check_error(error, "walk HEAD");

  error = git_repository_odb(&odb, repo);
  check_error(error, "open ODB");

  while(0 == git_revwalk_next(&commit_oid, walk)) {
    error = git_commit_lookup(&commit, repo, &commit_oid);
    check_error(error, "lookup commit");

    error = git_commit_tree(&tree, commit);
    check_error(error, "get tree");

    error = git_tree_walk(tree, GIT_TREEWALK_PRE, each_entry, odb);
    check_error(error, "walk tree");

    git_tree_free(tree);
  }

  git_revwalk_free(walk);
  git_odb_free(odb);
}
