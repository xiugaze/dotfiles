 {config, pkgs, lib, ...}:
 
 let
   cfg = config.services.skrimp_server;
 in
 
 with lib;
 
 {
   options = {
     services.skrimp_server = {
       enable = mkOption {
         default = false;
         type = with types; bool;
         description = ''
           Start server
         '';
       };
 
       user = mkOption {
         default = "username";
         type = with types; uniq string;
         description = ''
           Name of the user.
         '';
       };
     };
   };
 
   config = mkIf cfg.enable {
     networking.firewall.allowedTCPPorts = [ 25565 25567 ];
     networking.firewall.allowedUDPPorts = [ 25565 25567 ];
     systemd.services.skrimp_server = {
       wantedBy = [ "default.target" ]; 
       after = [ "network.target" ];
       description = "Start the skrimp shack";
       serviceConfig = {
         Type = "simple";
         User = "${cfg.user}";
         WorkingDirectory = /home/caleb/minecraft/skrimp_server;
         ExecStart = 
             let start = pkgs.writeShellApplication {
                 name = "skrimp-server-start";
                 runtimeInputs = with pkgs; [ jdk21_headless ];
                 text = ''
                   cd /home/caleb/minecraft/skrimp_server
                   java -Xms12G -Xmx12G -jar server.jar nogui
                 '';
               };
              in 
                lib.getExe start;
         ExecStop = 
             let stop = pkgs.writeShellApplication {
               name = "skrimp-server-stop";
               runtimeInputs = with pkgs; [ mcrcon ];
               text = ''
                  mcrcon -H localhost -P 25575 -p "popo" stop

                  while kill -0 "$MAINPID" 2>/dev/null
                  do
                    sleep 0.5
                  done
               '';
             };
           in 
            lib.getExe stop;
       };
     };
   };

}
