init() {
    setDvar("scr_allowFileIo", "1");

    level thread onPlayerConnected();
    level thread onPlayerSay();

    level thread onKillcam();
    level thread onKillcamEnd();

    level thread onGameEnded();

    level.onplayerkilled = ::onPlayerKilled;

}

onPlayerConnected() {
    for(;;) {
        level waittill( "connected", player );
        thread call_event("player_connected", player.name);

        player thread onPlayerSpawned();
        player thread onPlayerDeath();
        player thread onPlayerDisconnect();
    }
}

onPlayerSpawned() {
    for(;;) {
        self waittill( "spawned_player" );
        thread call_event("player_spawned", self.name);
    }
}

onPlayerDeath() {
    for(;;) {
        self waittill( "death" );
        thread call_event("player_death", self.name);
    }
}

onPlayerKilled(einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration) {
    thread call_event("player_killed", self.name, attacker.name, smeansofdeath);
}

onPlayerDisconnect() {
    for(;;) {
        self waittill( "disconnect" );
        thread call_event("player_disconnect", self.name);
    }
}

onPlayerSay() {
    for(;;) {
        level waittill( "say", message, player );
        thread call_event("player_say", player.name, message);
    }
}

onKillcam() {
    for(;;) {
        if (level.finalkillcam_winner != undefined) {
            thread call_event("killcam");
            wait 15;
        }
        wait .05;
    }
}

onKillcamEnd() {
    for(;;) {
        level waittill( "final_killcam_done" );
        thread call_event("killcam_end");
    }
}

call_event( event, arg1, arg2, arg3 ) {
    if (arg1 == undefined || arg1 == "" ) {
        event_log = "{ \"event\": \"" + event + "\" }";
    } 

    else if (arg2 == undefined || arg2 == "") {
        event_log = "{ \"event\": \"" + event + "\", \"args\": [\"" + arg1 + "\"] }";
    } 

    else if (arg3 == undefined || arg3 == "" ) {
        event_log = "{ \"event\": \"" + event + "\", \"args\": [\"" + arg1 + "\", \"" + arg2 + "\"] }";
    }

    else {
        event_log = "{ \"event\": \"" + event + "\", \"args\": [\"" + arg1 + "\", \"" + arg2 + "\", \"" + arg3 + "\"] }";
    }
    
    file = fs_fopen("event_" + event + ".jsonl", "append");
    fs_write(file, event_log + "\n");
    fs_fclose(file);

    println("^2[event]: " + event_log);
}