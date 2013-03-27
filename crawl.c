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
each_object(const git_oid *id, void *payload)
{
  int error;
  git_odb *odb = payload;
  git_odb_object *object;

  error = git_odb_read(&object, odb, id);
  check_error(error, "lookup object");

  printf("%zd\n", git_odb_object_size(object));

  git_odb_object_free(object);

  return 0;
}

int
main(int argc, char **argv)
{
  int error;
  const char *repo_path = argc == 2 ? argv[1] : ".";
  git_repository *repo;
  git_odb *odb;

  error = git_repository_open(&repo, repo_path);
  check_error(error, "open repository");

  error = git_repository_odb(&odb, repo);
  check_error(error, "open ODB");

  error = git_odb_foreach(odb, each_object, odb);
  check_error(error, "foreach object");

  git_odb_free(odb);
}
