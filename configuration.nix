{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  environment.systemPackages = with pkgs; [
    (import ./vim.nix)
    fzf
    git
    tmux
    silver-searcher
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "prohibit-password";

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCmOQ/koFIJKXFOrT/qYtF2UFtwv7mNKk6iSXTxlvbS21XqPiBx7NhqNrZ8ODunn9pn2L3lzxpTHmLOoAc2lFGGo6FoUGazv8lBWKQDgQIg5ZHhw2kHffcKpHhuQ4MgmkumCgv++ELMbEcZi7SsXQpjCk9dJqfE/hmz482035TnkpKxV6LED4hj98nnBL61WdgT98uYGa6RJKgK9EsEV/v4dFoUapciiTQ9dhmnxTGQL3c4nqmsmri4t+pYXAxNeAh8f/Rj9X0MblCZVZZVgE8ZmRB2J15/J8xF0fQCkhZ3bzR1D91ubIJmk0gZSvRbEH8S89KrnFIrCzp8twD/NbJqA+IdMc3dUphYIIWaLPthJSbl2+r+rFCDLXuvelOu+FIhseeBU1YYIeYg0OEyPUmkivGIURrodDSqo+LO8anZSpxS8Mkh245Vgbbthg76URaftRjVcIe4DU/qFe220C14e3B9ouOl58BBt1Vy9neB4GqROFkXbxd4/yyyfMRlnaeA9YGkrY0hFmwvkYmcpk8Q25PBUzKJ1cs/VtLnAOHjHFRwF9N3gJaO4lS34HzwQi5WpVtdqrU6h9sY0fv65boH85DOWihII9hxFDa5kjll4ZNHz5OosqW2QRDdoFu7bcnPUWPDurMspQ5f2nrmNoMU0jopCrndDvwNStKoIGBgZQ== wilson@t480"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAEAQDhOBOsb/C16I1Ahw0rHFw1YQSPdwgZMGhSFjyX4CCSbTmcKxuw/DsiN4ZTcTFCfMLr8MKShI9PH+JqkTuS6M4umGAIeBoaBt7Rc5e0oDh8I9N6SRHCl5555ECbmDOwtUED1C5dXs1705fKUOgGmxP6/3/ugZJu4Eswp19HhAk7ktq4WK8TXWkrKFe/xPROHcJJ0J/7sF9u0snad1uG9jpYSJUrxaVVJXHrufe2uxhwqaHZlpU4ghyvR1zBHBaakmk/wi+s/HzPvFpWn1n/nfaUp0KXbVRK0MDbi9ERRG4qkEVzViYiMe4uqyseTQoD+hk9GsieFNPIKn7sRRmUnbLdX56tHdapKPIvYU3My7yd+NL4Xy02U+izk2vH+PiMvyrqNZSNkg6MthJZs5OrQrplf7E6b0MSFJ4p++a/Qd5k1l8BCZjGWPL3hYqLog0QsXmMLTI0irpQcCD7mFJMHkeQRY4RUjUFJ+TolFmhwBdlslI7N2V4y4jqBkr2IZQUlx4DyGWm+jjrv7nkAtlORi8ViWMJZepNq8WPEHQRWPU9JsHZEIvVioegqeYJTjdK0g0WgUBzMNYBmyCQc+fn1lvZnEEgWCbZufeoJ+X8CUhEMNynKMEw5kpr9ShVyWqdgcrXETzo/KGoXHTJ2BJ63YkzGYMc6zbE44EtAdIkkN10AS3OG3nw8GQq4IYgtUcGU8+/0EfAdVCghZEbUza4ZG5AL+iCEzc++BG7FksxMs89oP7Myv8Th6UvHB4wkdhZqOnOoEeGLRW32YPi6B9ff5JLwG+OuxIKMoKM7i0pEVi1zyA7GNtZW0CzOBDHhGEnnevSkhQoa9IeNsDodwrMmjsVznUvePvE36sw0VyJETr4hzFMVejo3p6uEo5We9B/pgDnqlj+0PyWdmDSDAHfHZW/9ARzpU/FbkdC2Au5qdxlalz5CCxg70gGcVGvbhh6R8Wgn1Y6TTfR9aAB1I8I/xlbZVtCdP6yIGdr+htn/I/0smawCMOPoj82FuCSuL4uiHhbEEZQAfV8H3tC1xMdBLA0ZY8ZfMLjWjJjawREIt3x9g0OsOBr/a8KdYGRbgc/ckPgacOOQM0ae6zeWJR1YF1xOO3z0AWhsJYiJIbxkKB87+Dg4w6en/WOkiv597eEqEH5ZJJhKP14Jx3aGqbSlk8aqn3T3LdZh8xHXwoy6nY1FpcXjkCY9/p3UaRQQPax8iZ4dT0B/+wzUK9DUsCM2A0Vt2t9GZa6B+6VAhEUZbnFWAzKUJ4UKi+j1L+PkxPJgjxO1Jz5vWALGnam1PbRvI4eUKvINo1gklV9oSLPqnEmxalOf6HWHMTtpGCJWLcQ2nBnMSNfrejUizbaTp/vqfld wilsonhusin@WilsonMBP.local"
    ];
  };

  system.stateVersion = "19.03";
}
