# Git（身份与签名密钥单独放，不与其他 program 混）
_:

{
  programs.git = {
    enable = true;
    signing.key = "114FF4118D3C886A";
    signing.signByDefault = true;
    settings = {
      user.name = "LinTrau";
      user.email = "eddyjarnaginbzw15@gmail.com";
    };
  };
}
