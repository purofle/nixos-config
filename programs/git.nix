{
  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "purofle@gmail.com";
        name = "purofle";
      };
      commit = {
        gpgSign = true;
      };
    };
    includes = [
      {
        condition = "gitdir:~/work/";
        path = "~/work/.gitconfig";
      }
    ];
  };
}
