_self: super: {
  ast-grep = super.ast-grep.overrideAttrs (old: {
    doCheck = false;
  });
}
